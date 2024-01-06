import asyncio
import contextlib
import dataclasses
import logging
import typing

import async_timer
import cv2
import numpy as np

from . import toolchanger, trackers, typ, vcap_source

logger = logging.getLogger(__name__)


@dataclasses.dataclass(frozen=True, kw_only=True)
class ScreenCoordCapture:
    printerCoords: typ.Point
    screenCoords: typ.Point


class XYConfigurator:
    tc: toolchanger.Toolchanger

    vcap: vcap_source.VCapSource
    window_title = "XY Config"
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

    def is_tracking(self) -> bool:
        return self.object_tracker.state().is_tracking()

    async def wait_for_tracking(self):
        while not self.is_tracking():
            logger.info("Waiting for the tracking point to be set...")
            await asyncio.sleep(3)

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
    async def restore_pos(self):
        with self.tc.gcode.restore_pos() as final_p:
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

    async def jiggle(self):
        """Jiggle the printer head a bit"""
        async with self.restore_pos() as restore_p:
            with self.tc.gcode.tmp_settings():
                self.tc.gcode.send(
                    "\n".join(
                        [
                            "G91",
                        ]
                        + (
                            [
                                "G0 X20 F9999",
                                "G0 Y20",
                                "G0 X-20 Y-20",
                                "G0 X-30 Y-30",
                                "G0 X30 Y30",
                            ]
                            * 2
                        )
                        + ["M400"]
                    )
                )
        await self.wait_move_to_complete(15, restore_p)

    async def infer_coord_transform(
        self, step: float = 1.0
    ) -> typing.Callable[[typ.Point], typ.Point]:
        def capture_coords() -> ScreenCoordCapture:
            """Return tuple of (screen coords, printer coords)"""
            if not self.is_tracking():
                raise RuntimeError("Tracking point is lost.")
            return ScreenCoordCapture(
                printerCoords=self.tc.get_coords(),
                screenCoords=self.object_tracker.state().representative_point,
            )

        async def _measure_apparent_move_dist(dx=0, dy=0) -> ScreenCoordCapture:
            async with self.restore_pos():
                self.tc.gcode.rel_move(dx=dx, dy=dy)
                await self.wait_move_to_complete()

                return capture_coords()

        await self.wait_for_tracking()
        measured_points: list[ScreenCoordCapture] = [capture_coords()]
        for world_move in [[2, 0], [0, 2]]:
            coord_pair = await _measure_apparent_move_dist(
                dx=world_move[0] * step, dy=world_move[1] * step
            )
            measured_points.append(coord_pair)

        np_screen_coords = np.array(
            [[p.screenCoords.x, p.screenCoords.y] for p in measured_points]
        )
        np_printer_coords = np.array(
            [[p.printerCoords.x, p.printerCoords.y] for p in measured_points]
        )

        A = np.vstack([np_screen_coords.T, np.ones(np_screen_coords.shape[0])]).T
        (solution, res, rank, s) = np.linalg.lstsq(A, np_printer_coords, rcond=None)

        def _get_printer_coords(screen_p: typ.Point):
            rv = np.dot(np.array([[screen_p.x, screen_p.y, 1.0]]), solution)
            assert rv.shape == (1, 2)
            return typ.Point(x=rv[0][0], y=rv[0][1])

        return _get_printer_coords

    async def update_tool_offsets(self):
        screen_mid = typ.Point(x=self.width / 2, y=self.height / 2)
        tc_tools = self.tc.get_tools()
        approx_offset = await self.infer_coord_transform(0.2)
        approx_mid = approx_offset(screen_mid)
        await self.abs_move(approx_mid)
        precise_no_tool_offset = await self.infer_coord_transform()
        await self.abs_move(precise_no_tool_offset(screen_mid))
        async with self.restore_pos(), self.restore_tool():
            for tool in tc_tools:
                await self.wait_tool_change(tool.name)
                await self.abs_move(precise_no_tool_offset(screen_mid))
                await self.jiggle()
                precise_tool_offset = await self.infer_coord_transform()
                await self.abs_move(precise_tool_offset(screen_mid))
        logger.info("All done")

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
