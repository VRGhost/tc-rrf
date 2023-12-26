import asyncio
import contextlib
import dataclasses
import logging

import async_timer
import cv2
import numpy as np

logger = logging.getLogger(__name__)


@dataclasses.dataclass(frozen=True, slots=True)
class Circle:
    x: int
    y: int
    r: int


@dataclasses.dataclass(frozen=True, slots=True)
class Point:
    x: float
    y: float


class DecayingAvgPoint:
    x: float = None
    y: float = None
    new_weight: float

    def __init__(self, new_val_weight):
        self.new_weight = new_val_weight

    def set(self, x, y):
        self.x = x
        self.y = y

    def add(self, x, y):
        if not self:
            self.set(x, y)
        else:
            self.x = self.x * (1 - self.new_weight) + x * self.new_weight
            self.y = self.y * (1 - self.new_weight) + y * self.new_weight

    def __bool__(self):
        return None not in (self.x, self.y)

    def point(self):
        return Point(self.x, self.y)


class XYConfigurator:
    vcap: cv2.VideoCapture
    window_title = "XY Config"
    width: int
    height: int

    target_circle: Circle = None
    other_circles: tuple[Circle] = ()
    target_pos_10: DecayingAvgPoint
    target_pos_100: DecayingAvgPoint
    frame_source: async_timer.Timer[object]

    def __init__(self, vcap, duet_api):
        cv2.namedWindow(self.window_title)
        cv2.setMouseCallback(self.window_title, self.mouse_cb)
        self.vcap = vcap
        self.duet_api = duet_api
        self.width = int(self.vcap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(self.vcap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.fps = self.vcap.get(cv2.CAP_PROP_FPS)
        self.target_pos_10 = DecayingAvgPoint(1 / 5)
        self.target_pos_100 = DecayingAvgPoint(1 / 10)
        self.target_pos_10.add(100, 100)
        self.target_pos_100.add(0, 0)

    def get_printer_coords(self) -> Point:
        api_coords = self.duet_api.get_coords()
        return Point(x=api_coords["X"], y=api_coords["Y"])

    def send_g_code(self, code: str):
        return self.duet_api.send_code(code)

    def find_circles(self, frame):
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gray_blurred = cv2.blur(gray_frame, (3, 3))

        if self.target_circle:
            pct_delta = 30
            r = self.target_circle.r
            cx = self.target_circle.x
            cy = self.target_circle.y

            min_r = r * (1 - (100 / pct_delta))
            min_r = max(min_r, 50)
            max_r = r * (1 + (100 / pct_delta))

            min_x = int(max(cx - 1.2 * r, 0))
            min_y = int(max(cy - 1.2 * r, 0))
            max_x = int(min(cx + 1.2 * r, self.width))
            max_y = int(min(cy + 1.2 * r, self.height))
            gray_blurred = gray_blurred[min_y:max_y, min_x:max_x]
            cv2.imshow("cropped", gray_blurred)
            offset_x = min_x
            offset_y = min_y
        else:
            min_r = 50
            max_r = 200
            offset_x = offset_y = 0
        min_dist = max_r - min_r
        detected_circles = cv2.HoughCircles(
            gray_blurred,
            cv2.HOUGH_GRADIENT,
            1,
            int(min_dist),
            param1=50,
            param2=30,
            minRadius=int(min_r),
            maxRadius=int(max_r),
        )
        if detected_circles is not None:
            # Convert the circle parameters a, b and r to integers.
            circles = []
            detected_circles = np.int64(np.around(detected_circles))
            for pt in detected_circles[0, :]:
                circles.append(Circle(pt[0] + offset_x, pt[1] + offset_y, pt[2]))
            self.other_circles = tuple(circles)
            if self.target_circle:
                self.target_circle = self.find_closest_circle(
                    self.target_circle.x, self.target_circle.y, self.other_circles
                )

    def mouse_cb(self, event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONUP:
            print(f"mouse @ {x=} {y=}")
            self.target_circle = self.find_closest_circle(x, y)
            if self.target_circle:
                r = self.target_circle.r
                self.target_pos_10.set(
                    self.target_circle.x - r, self.target_circle.y + r
                )
                self.target_pos_100.set(
                    self.target_circle.x + r, self.target_circle.y - r
                )

    def find_closest_circle(self, x, y, all_circles=None):
        if all_circles is None:
            all_circles = list(self.other_circles)
            if self.target_circle:
                all_circles.append(self.target_circle)
        all_cicles_with_dist = []
        for circle in all_circles:
            sq_dist = (circle.x - x) ** 2 + (circle.y - y) ** 2
            if sq_dist <= circle.r**2:
                all_cicles_with_dist.append((sq_dist, circle))
        all_cicles_with_dist.sort(key=lambda el: el[0])
        if all_cicles_with_dist:
            return all_cicles_with_dist[0][1]

    def get_frames(self):
        yellow_c = (255, 255, 0)
        while True:
            (ret, frame) = self.vcap.read()
            self.find_circles(frame)
            if self.target_circle:
                self.target_pos_10.add(self.target_circle.x, self.target_circle.y)
                self.target_pos_100.add(self.target_circle.x, self.target_circle.y)

            line_thickness = 2
            for circle in self.other_circles:
                cv2.circle(frame, (circle.x, circle.y), circle.r, (0, 100, 0), 2)
            if self.target_circle:
                cv2.circle(
                    frame,
                    (self.target_circle.x, self.target_circle.y),
                    self.target_circle.r,
                    (0, 150, 0),
                    2,
                )
                cv2.circle(
                    frame,
                    (self.target_circle.x, self.target_circle.y),
                    1,
                    (150, 0, 0),
                    3,
                )

            if self.target_pos_10:
                cv2.circle(
                    frame,
                    (int(self.target_pos_10.x), int(self.target_pos_10.y)),
                    1,
                    (205, 205, 205),
                )
            if self.target_pos_100:
                cv2.circle(
                    frame,
                    (int(self.target_pos_100.x), int(self.target_pos_100.y)),
                    1,
                    (205, 205, 205),
                    3,
                )

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
            yield frame

    def abs_move(self, p: Point):
        self.send_g_code(
            f"""
                G0 X{p.x} Y{p.y}
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

    @contextlib.contextmanager
    def restore_pos(self):
        coords = self.duet_api.get_coords()
        print(coords)
        yield
        self.send_g_code(f"G0 X{coords['X']} Y{coords['Y']} Z{coords['Z']}")

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
        return self.target_circle is not None

    def is_stable(self) -> bool:
        if not (self.is_tracking() and self.target_pos_10 and self.target_pos_100):
            return False
        dx = (self.target_pos_10.x - self.target_pos_100.x) ** 2
        dy = (self.target_pos_10.y - self.target_pos_100.y) ** 2
        return (dx + dy) < 2

    def is_unstable(self) -> bool:
        if not (self.is_tracking() and self.target_pos_10 and self.target_pos_100):
            return False
        dx = (self.target_pos_10.x - self.target_pos_100.x) ** 2
        dy = (self.target_pos_10.y - self.target_pos_100.y) ** 2
        return (dx + dy) > 3

    async def wait_for_tracking(self):
        while not self.is_tracking():
            await asyncio.sleep(0.5)

    async def wait_for_move_to_start(self):
        await self.wait_for_tracking()
        while not self.is_unstable():
            await asyncio.sleep(0.1)

    async def wait_for_move_to_stabilise(self):
        await self.wait_for_tracking()
        while not self.is_stable():
            await asyncio.sleep(0.5)

    async def wait_move_to_happen(self):
        await self.wait_for_move_to_start()
        await self.wait_for_move_to_stabilise()

    async def wait_tool_change(self, tool: str | int):
        print("AAA")
        if isinstance(tool, int):
            tool_name = f"T{tool}"
        else:
            tool_name = tool
        tools_info = self.duet_api.get_model(key="tools")
        expected_state = {el["name"]: (el["name"] == tool_name) for el in tools_info}
        print(expected_state)
        self.send_g_code(tool_name)
        while True:
            tools_info = self.duet_api.get_model(key="tools")
            status = {el["name"]: (el["state"] == "active") for el in tools_info}
            print(status, expected_state)
            if status == expected_state:
                break
            else:
                await asyncio.sleep(0.5)

        return tool_name

    async def infer_coord_transform(self, step: float = 1.0):
        def capture_coords() -> tuple[Point, Point]:
            """Return tuple of (screen coords, printer coords)"""
            return (self.get_printer_coords(), self.target_pos_10.point())

        async def _measure_apparent_move_dist(dx=0, dy=0):
            await self.wait_for_move_to_stabilise()
            with self.tmp_settings():
                self.rel_move(dx=dx, dy=dy)
                await self.wait_move_to_happen()

                rv = capture_coords()
                self.rel_move(dx=-dx, dy=-dy)
                await self.wait_for_move_to_stabilise()

            return rv

        await self.wait_for_move_to_stabilise()
        measured_points = [capture_coords()]
        for world_move in [[1, 2], [2, 1], [1, 0]]:
            coord_pair = await _measure_apparent_move_dist(
                dx=world_move[0] * step, dy=world_move[1] * step
            )
            measured_points.append(coord_pair)

        np_screen_coords = np.array([[p[0].x, p[0].y] for p in measured_points])
        np_printer_coords = np.array([[p[1].x, p[1].y] for p in measured_points])

        A = np.vstack([np_printer_coords.T, np.ones(np_printer_coords.shape[0])]).T
        (solution, res, rank, s) = np.linalg.lstsq(A, np_screen_coords, rcond=None)

        def _get_printer_coords(screen_p: Point):
            rv = np.dot(np.array([[screen_p.x, screen_p.y, 1.0]]), solution)
            assert rv.shape == (1, 2)
            return Point(x=rv[0][0], y=rv[0][1])

        return _get_printer_coords

    async def update_tool_offsets(self):
        await self.wait_tool_change("T1")
        await self.wait_tool_change("T2")
        await self.wait_tool_change("T-1")
        screen_mid = Point(x=self.width / 2, y=self.height / 2)
        tc_tools = self.duet_api.get_model(key="tools[]")
        approx_offset = await self.infer_coord_transform(0.2)
        approx_mid = approx_offset(screen_mid)
        self.abs_move(approx_mid)
        precise_no_tool_offset = await self.infer_coord_transform()
        self.abs_move(precise_no_tool_offset(screen_mid))
        try:
            for tool_rec in tc_tools[:1]:
                self.send_g_code(tool_rec["name"])
                self.abs_move(precise_no_tool_offset(screen_mid))
                await asyncio.sleep(20)
        finally:
            self.send_g_code("T-1")  # disarm
        logger.info("All done")

    async def run(self):
        self.screen_coords_to_printer = asyncio.create_task(self.update_tool_offsets())
        self.frame_source = async_timer.Timer(10e-10, self.get_frames)
        self.frame_source.start()
        async for frame in self.frame_source:
            cv2.imshow(self.window_title, frame)
            key = cv2.waitKey(1)
            if key == 27 or cv2.getWindowProperty(self.window_title, 0) < 0:
                break
            await asyncio.sleep(0.01)
