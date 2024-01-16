import asyncio
import contextlib
import enum
import logging
import typing

import async_timer
import cv2

from . import coord_inference, toolchanger, trackers, typ, vcap_source

logger = logging.getLogger(__name__)


class FeedRates(int, enum.Enum):
    TRACKING = 40
    MAX_SPEED = 99_999


class ZConfigurator:
    tc: toolchanger.Toolchanger

    vcap: vcap_source.VCapSource
    window_title = "Z Config"
    width: int
    height: int

    object_tracker: trackers.hough_object_tracker.HoughTracker
    motion_tracker: trackers.motion_tracker.Odometer
    frame_source: async_timer.Timer[object]

    def __init__(self, vcap, duet_api):
        cv2.namedWindow(self.window_title)
        cv2.setMouseCallback(self.window_title, self.mouse_cb)
        self.vcap = vcap_source.VCapSource(vcap)
        self.object_tracker = trackers.optical_flow_tracker.OpticalFlowTracker()
        self.motion_tracker = trackers.motion_tracker.Odometer()
        self.tc = toolchanger.Toolchanger(duet_api)
        self.width = int(vcap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(vcap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.fps = vcap.get(cv2.CAP_PROP_FPS)

    def mouse_cb(self, event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONUP:
            logger.debug(f"mouse @ {x=} {y=}")
            self.object_tracker.set_interesting_point(x, y)

    async def get_frames(self):
        yellow_c = (255, 255, 0)
        async for (_ret, frame) in self.vcap.async_read():
            self.object_tracker.push(frame)
            self.motion_tracker.push(frame)

            # Draw crosshair
            line_thickness = 1
            cv2.line(
                frame,
                (self.width // 2, 10),
                (self.width // 2, self.height - 10),
                color=yellow_c,
                thickness=line_thickness,
            )
            cv2.line(
                frame,
                (10, self.height // 2),
                (self.width - 10, self.height // 2),
                color=yellow_c,
                thickness=line_thickness,
            )

            # Draw trackers' UIs
            frame = self.motion_tracker.draw_ui_overlay(frame)
            frame = self.object_tracker.draw_ui_overlay(frame)

            yield frame

    def screen_mid(self) -> typ.Point:
        return typ.Point(x=self.width / 2, y=self.height / 2, z=0)

    def is_tracking(self) -> bool:
        return self.object_tracker.state().is_tracking()

    def cur_feed_rate(self) -> float | None:
        if self.is_tracking():
            return FeedRates.TRACKING.value
        return None

    async def wait_for_tracking(self) -> trackers.hough_object_tracker.TrackerState:
        while not self.is_tracking():
            logger.info("Waiting for the tracking point to be set...")
            await asyncio.sleep(0.5)
        return self.object_tracker.state()

    async def wait_move_to_complete(
        self, timeout: int | float = 20, target_pos: typ.Point = None
    ):
        wait_for_motion_to_start = True
        if target_pos is not None:
            # Check if the desired move is too small
            curent_pos = self.tc.get_coords()
            if (curent_pos - target_pos).len() < 0.05:  # mm in printer units
                logger.info("The desired move is too small.")
                wait_for_motion_to_start = False

        if wait_for_motion_to_start:
            try:
                async with asyncio.timeout(timeout):
                    await self.motion_tracker.wait_for_motion_to_start()
            except TimeoutError:
                logger.warn(
                    "Waiting for move to complete timed out. Maybe a very small move was attempted?"
                )
        else:
            await asyncio.sleep(0.5)
        await self.motion_tracker.wait_for_motion_to_stop()

    async def wait_tool_change(self, tool: str | int):
        if isinstance(tool, int):
            tool_name = f"T{tool}"
        else:
            tool_name = tool
        tools_info = self.tc.get_tools()

        expected_state = {el.name: (el.name == tool_name) for el in tools_info}
        assert tool in expected_state, f"Tool {tool} must be known to the printer"
        async with self.restore_pos():
            self.tc.gcode.send(tool_name)

            while True:
                tools_info = self.tc.get_tools()
                status = {el.name: el.active for el in tools_info}
                if status == expected_state:
                    break
                else:
                    await asyncio.sleep(0.5)

        return tool_name

    @contextlib.asynccontextmanager
    async def restore_pos(self, feed_rate: float | None = None):
        with self.tc.gcode.restore_pos(feed_rate or self.cur_feed_rate()) as final_p:
            yield
        await self.wait_move_to_complete(3, final_p)

    @contextlib.asynccontextmanager
    async def restore_tool(self):
        old_tool = self.tc.get_state().currentTool
        try:
            yield old_tool
        finally:
            end_tool = self.tc.get_state().currentTool
            if old_tool != end_tool:
                self.tc.gcode.send(f"T{old_tool}")
                await self.wait_move_to_complete(3)

    async def abs_move(self, point: typ.Point):
        self.tc.gcode.abs_move(point)
        await self.wait_move_to_complete(10, point)

    async def infer_tool_coord_transform(self):
        """Two-step process (if required)"""

        async def _capture_coords(rel_move: typ.Vector):
            """Return tuple of (screen coords, printer coords)"""
            if not self.is_tracking():
                raise RuntimeError("Tracking point is lost.")
            async with self.restore_pos():
                self.tc.gcode.rel_move(dx=rel_move.dx, dy=rel_move.dy, dz=rel_move.dz)
                await self.wait_move_to_complete(timeout=3)
                return coord_inference.ScreenCoordCapture(
                    printerCoords=self.tc.get_coords(),
                    screenCoords=self.object_tracker.state().representative_point,
                )

        tracker = await self.wait_for_tracking()
        screen_mid = self.screen_mid()
        dist_to_mid = (screen_mid - tracker.representative_point).len()
        if dist_to_mid > 40:
            approx_offset = await coord_inference.InferCoordTransform.xz().infer(
                capture_coords=_capture_coords,
                mul=0.1,
            )
            approx_mid = approx_offset(screen_mid)
            await self.abs_move(approx_mid)
        return await coord_inference.InferCoordTransform.xz().infer(
            capture_coords=_capture_coords, mul=2
        )

    async def infer_tool_correction(
        self,
        current_tool: toolchanger.toolchanger.Tool,
        axes: list[toolchanger.toolchanger.MoveAxis],
        screen_to_tc_coords: typing.Callable[[typ.Point], typ.Point],
    ) -> str:
        tc_tool_pos = self.tc.get_coords()
        screen_mid = self.screen_mid()
        screen_mid_printer_pos = screen_to_tc_coords(screen_mid)
        dist_to_centre = (screen_mid_printer_pos - tc_tool_pos).len()
        assert (
            dist_to_centre < 1
        ), f"The tool should be expected to be in the centre: {dist_to_centre}"
        x_axis_idx = [el for el in axes if el.letter == "X"][0].index
        y_axis_idx = [el for el in axes if el.letter == "Y"][0].index
        orig_tool_offset = typ.Point(
            x=current_tool.offsets[x_axis_idx], y=current_tool.offsets[y_axis_idx]
        )

        if orig_tool_offset.x == 0 and orig_tool_offset.y == 0:
            logger.error(f"{current_tool=} {axes=}")
            raise RuntimeError("Something weird is hapenning")

        def tool_update_cmd(desired):
            return f"G10 L1 P{current_tool.number} X{desired.x} Y{desired.y}"

        async def _capture_coords(rel_move: typ.Vector):
            """Return tuple of (screen coords, printer coords)"""
            if not self.is_tracking():
                raise RuntimeError("Tracking point is lost.")
            new_offset_p = orig_tool_offset + rel_move
            logging.debug(f"{orig_tool_offset=} {rel_move=} {new_offset_p=}")
            change_cmd = tool_update_cmd(new_offset_p)
            restore_cmd = tool_update_cmd(orig_tool_offset)

            self.tc.gcode.send(change_cmd)
            await asyncio.sleep(0.1)
            await self.abs_move(screen_mid_printer_pos)
            await self.wait_move_to_complete(timeout=3)
            try:
                return coord_inference.ScreenCoordCapture(
                    printerCoords=new_offset_p,
                    screenCoords=self.object_tracker.state().representative_point,
                )
            finally:
                self.tc.gcode.send(restore_cmd)

        await self.wait_for_tracking()
        offset_fn = await coord_inference.InferCoordTransform().infer(
            capture_coords=_capture_coords,
            mul=1,
        )
        desired_offset = offset_fn(screen_mid)
        gcode_cmd = tool_update_cmd(desired_offset)
        self.tc.gcode.send(gcode_cmd)
        await asyncio.sleep(0.1)
        await self.abs_move(screen_mid_printer_pos)
        await asyncio.sleep(10)

        message = f"""
            Please change offset of {current_tool.name} to X = {desired_offset.x} & Y = {desired_offset.y}
            Used gcode command: {gcode_cmd}
        """
        logger.info(f">>> {message}")
        return message

    async def update_tool_offsets(self):
        screen_mid = self.screen_mid()
        tc_tools = self.tc.get_tools()
        axes_info = self.tc.get_axes_info()
        precise_no_tool_offset = await self.infer_tool_coord_transform()
        await self.abs_move(precise_no_tool_offset(screen_mid))
        # messages = []
        # async with self.restore_pos(FeedRates.MAX_SPEED.value), self.restore_tool():
        #     for tool in tc_tools:
        #         await self.wait_tool_change(tool.name)
        #         await self.abs_move(precise_no_tool_offset(screen_mid))
        #         updated_tool_info = self.tc.get_tools()[tool.index]
        #         msg = await self.infer_tool_correction(
        #             updated_tool_info, axes_info, precise_no_tool_offset
        #         )
        #         messages.append(msg)
        logger.info("All done")
        print("=" * 150)
        print("\n".join(messages))

    async def process_frames(self):
        async for frame in self.get_frames():
            cv2.imshow(self.window_title, frame)
            key = cv2.waitKey(1)
            if key == 27 or cv2.getWindowProperty(self.window_title, 0) < 0:
                break
            await asyncio.sleep(0.01)

    async def run(self):
        tasks = [
            asyncio.create_task(self.update_tool_offsets()),
            asyncio.create_task(self.process_frames()),
        ]
        await asyncio.wait(tasks, return_when=asyncio.FIRST_COMPLETED)
        for t in tasks:
            if not t.done():
                t.cancel()
