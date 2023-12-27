import dataclasses

import cv2
import numpy as np

from .. import typ


@dataclasses.dataclass(slots=True, frozen=True)
class TrackerState:
    representative_point: typ.Point
    _avg_dsum: float = 0.0

    def is_tracking(self):
        return self.representative_point is not None

    def pos_certain(self):
        return self.is_tracking() and self._avg_dsum < 2


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
        return typ.Point(self.x, self.y)


class HoughTracker:
    all_circles: list[typ.Circle]
    target_circle: typ.Circle = None
    avg_fast: DecayingAvgPoint
    avg_slow: DecayingAvgPoint

    def __init__(self):
        self.all_circles = []
        self.avg_fast = DecayingAvgPoint(1 / 3.0)
        self.avg_slow = DecayingAvgPoint(1 / 10.0)

    def state(self) -> TrackerState:
        avg_dsum = 0
        repr_point = None
        if self.target_circle:
            avg_dx = (self.avg_fast.x - self.avg_slow.x) ** 2
            avg_dy = (self.avg_fast.y - self.avg_slow.y) ** 2
            avg_dsum = avg_dx + avg_dy
            repr_point = self.avg_fast.point()

        return TrackerState(
            representative_point=repr_point,
            _avg_dsum=avg_dsum,
        )

    def draw_ui_overlay(self, frame: typ.VideoFrame) -> typ.VideoFrame:
        def _circle_to_kp(circ):
            return cv2.KeyPoint(x=float(circ.x), y=float(circ.y), size=float(circ.r))

        # All circles
        frame = cv2.drawKeypoints(
            frame,
            [_circle_to_kp(circ) for circ in self.all_circles],
            0,
            (0, 0, 255),
            flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS,
        )
        if self.target_circle:
            frame = cv2.drawKeypoints(
                frame,
                # Target circle
                [_circle_to_kp(self.target_circle)],
                0,
                (0, 255, 255),
                flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS,
            )
            frame = cv2.drawKeypoints(
                frame,
                # Tracking points
                [
                    cv2.KeyPoint(
                        x=float(self.avg_fast.x), y=float(self.avg_fast.y), size=1.0
                    ),
                    cv2.KeyPoint(
                        x=float(self.avg_slow.x), y=float(self.avg_slow.y), size=10.0
                    ),
                ],
                0,
                (0, 255, 0),
                flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS,
            )
        return frame

    def push(self, frame):
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gray_blurred = cv2.blur(gray_frame, (3, 3))

        min_r = 50
        max_r = 150

        min_dist = 150
        detected_circles = cv2.HoughCircles(
            gray_blurred,
            cv2.HOUGH_GRADIENT,
            dp=1,
            minDist=int(min_dist),
            param1=55,
            param2=30,
            minRadius=int(min_r),
            maxRadius=int(max_r),
        )
        if detected_circles is not None:
            # Convert the circle parameters a, b and r to integers.
            circles = []
            detected_circles = np.int64(np.around(detected_circles))
            for pt in detected_circles[0, :]:
                circles.append(typ.Circle(pt[0], pt[1], pt[2]))
                if len(circles) > 10:
                    break
            self.all_circles = tuple(circles)
            if self.target_circle:
                self.target_circle = self.find_closest_circle(
                    self.target_circle.x, self.target_circle.y, self.all_circles
                )
        if self.target_circle:
            self.avg_slow.add(self.target_circle.x, self.target_circle.y)
            self.avg_fast.add(self.target_circle.x, self.target_circle.y)
        else:
            self.avg_fast.set(None, None)
            self.avg_slow.set(None, None)

    def find_closest_circle(self, x, y, all_circles=None):
        if all_circles is None:
            all_circles = list(self.all_circles)
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

    def set_interesting_points(self, x, y):
        self.target_circle = self.find_closest_circle(x, y)
        if self.target_circle:
            self.avg_slow.set(
                self.target_circle.x, self.target_circle.y - self.target_circle.r / 2
            )
            self.avg_fast.set(
                self.target_circle.x, self.target_circle.y + self.target_circle.r / 2
            )
