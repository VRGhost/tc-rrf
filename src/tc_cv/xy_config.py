import asyncio
import contextlib
import logging

import async_timer
import cv2
import numpy as np

from . import trackers, typ, vcap_source

logger = logging.getLogger(__name__)


class XYConfigurator:
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
        self.duet_api = duet_api
        self.width = int(vcap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(vcap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.fps = vcap.get(cv2.CAP_PROP_FPS)

    def get_printer_coords(self) -> typ.Point:
        api_coords = self.duet_api.get_coords()
        return typ.Point(x=api_coords["X"], y=api_coords["Y"])

    def send_g_code(self, code: str):
        return self.duet_api.send_code(code)

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

    def abs_move(self, p: typ.Point, feed: float = 45.0):
        with self.tmp_settings():
            self.send_g_code(
                f"""
                    G0 X{p.x} Y{p.y} F{feed}
                    M400
                """
            )

    @contextlib.contextmanager
    def tmp_settings(self):
        self.send_g_code("M120")  # save settings
        try:
            yield
        finally:
            self.send_g_code("M121")

    @contextlib.asynccontextmanager
    async def restore_pos(self):
        coords = self.duet_api.get_coords()
        yield
        self.send_g_code(f"G0 X{coords['X']} Y{coords['Y']} Z{coords['Z']}")
        await self.wait_move_to_complete(3)

    def rel_move(
        self,
        dx: float = 0.0,
        dy: float = 0.0,
        dz: float = 0.0,
        feed: float = 45.0,
    ):
        with self.tmp_settings():
            self.send_g_code(
                f"""
                    M400 ; wait for any pending moves to complete
                    G91
                    G1 X{dx} Y{dy} Z{dz} F{feed}
                    M400 ; wait for any pending moves to complete
                """
            )

    def is_tracking(self) -> bool:
        return self.object_tracker.state().is_tracking()

    def is_stable(self) -> bool:
        return self.object_tracker.state().pos_certain()

    async def wait_for_tracking(self):
        while not self.is_tracking():
            await asyncio.sleep(0.5)

    async def wait_for_move_to_stabilise(self):
        await self.wait_for_tracking()
        while not self.is_stable():
            await asyncio.sleep(0.5)

    async def wait_move_to_complete(self, timeout=20):
        try:
            async with asyncio.timeout(timeout):
                await self.motion_tracker.wait_for_motion_to_start()
        except TimeoutError:
            logger.warn(
                "Waiting for move to complete timed out. Maybe a very small move was attempted?"
            )
        await self.motion_tracker.wait_for_motion_to_stop()
        await self.wait_for_move_to_stabilise()

    async def wait_tool_change(self, tool: str | int):
        if isinstance(tool, int):
            tool_name = f"T{tool}"
        else:
            tool_name = tool
        tools_info = self.duet_api.get_model(key="tools")
        expected_state = {el["name"]: (el["name"] == tool_name) for el in tools_info}
        async with self.restore_pos():
            self.send_g_code(tool_name)
        while True:
            tools_info = self.duet_api.get_model(key="tools")
            status = {el["name"]: (el["state"] == "active") for el in tools_info}
            if status == expected_state:
                break
            else:
                await asyncio.sleep(0.5)

        return tool_name

    async def infer_coord_transform(self, step: float = 1.0):
        def capture_coords() -> tuple[typ.Point, typ.Point]:
            """Return tuple of (screen coords, printer coords)"""
            return (
                self.get_printer_coords(),
                self.object_tracker.state().representative_point,
            )

        async def _measure_apparent_move_dist(dx=0, dy=0):
            await self.wait_for_move_to_stabilise()
            self.rel_move(dx=dx, dy=dy)
            await self.wait_move_to_complete()

            rv = capture_coords()
            self.rel_move(dx=-dx, dy=-dy)
            await self.wait_move_to_complete()

            return rv

        await self.wait_for_move_to_stabilise()
        measured_points = [capture_coords()]
        for world_move in [[2, 0], [0, 2]]:
            coord_pair = await _measure_apparent_move_dist(
                dx=world_move[0] * step, dy=world_move[1] * step
            )
            measured_points.append(coord_pair)

        np_screen_coords = np.array([[p[0].x, p[0].y] for p in measured_points])
        np_printer_coords = np.array([[p[1].x, p[1].y] for p in measured_points])

        A = np.vstack([np_printer_coords.T, np.ones(np_printer_coords.shape[0])]).T
        (solution, res, rank, s) = np.linalg.lstsq(A, np_screen_coords, rcond=None)

        def _get_printer_coords(screen_p: typ.Point):
            rv = np.dot(np.array([[screen_p.x, screen_p.y, 1.0]]), solution)
            assert rv.shape == (1, 2)
            return typ.Point(x=rv[0][0], y=rv[0][1])

        return _get_printer_coords

    async def update_tool_offsets(self):
        screen_mid = typ.Point(x=self.width / 2, y=self.height / 2)
        tc_tools = self.duet_api.get_model(key="tools[]")
        approx_offset = await self.infer_coord_transform(0.2)
        approx_mid = approx_offset(screen_mid)
        self.abs_move(approx_mid)
        await self.wait_move_to_complete(3)
        precise_no_tool_offset = await self.infer_coord_transform()
        self.abs_move(precise_no_tool_offset(screen_mid))
        await self.wait_move_to_complete(3)
        async with self.restore_pos():
            try:
                for tool_rec in tc_tools:
                    await self.wait_tool_change(tool_rec["name"])
                    self.abs_move(precise_no_tool_offset(screen_mid))
                    precise_tool_offset = await self.infer_coord_transform()
                    self.abs_move(precise_tool_offset(screen_mid))
                    await self.wait_move_to_complete(3)
            finally:
                self.send_g_code("T-1")  # disarm
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
