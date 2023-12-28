import dataclasses
import logging

import cv2
import numpy as np

from .. import typ

logger = logging.getLogger(__name__)


@dataclasses.dataclass(slots=True, frozen=True)
class TrackerState:
    _tracking: bool
    representative_point: typ.Point

    def is_tracking(self):
        return self._tracking

    def pos_certain(self):
        return True


class OpticalFlowTracker:
    feature_params = {  # Parameters for lucas kanade optical flow
        "maxCorners": 12,  # how many pts. to locate
        "qualityLevel": 0.01,  # b/w 0 & 1, min. quality below which everyone is rejected
        "minDistance": 3,  # min eucledian distance b/w corners detected
        "blockSize": 3,
    }

    lk_params = {
        "winSize": (15, 15),  # size of the search window at each pyramid level
        "maxLevel": 2,  #  0, pyramids are not used (single level), if set to 1, two levels are used, and so on
        "criteria": (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03),
    }

    tracked_features: np.ndarray = None
    feature_to_user_point_distances: np.ndarray = None
    initial_tracked_feature_count: int = None
    prev_gray_frame: typ.VideoFrame = None

    def state(self) -> TrackerState:
        return TrackerState(
            _tracking=self.is_tracking(),
            representative_point=self.user_point(),
        )

    def push(self, frame: typ.VideoFrame) -> typ.VideoFrame:
        gr_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        if self.is_tracking():
            old_up = self.user_point()
            new_points, st, err = cv2.calcOpticalFlowPyrLK(
                self.prev_gray_frame,
                gr_frame,
                self.tracked_features,
                None,
                **self.lk_params,
            )
            self.feature_to_user_point_distances = (
                self.feature_to_user_point_distances.reshape(-1, 1, 2)[st == 1]
            )
            self.tracked_features = new_points[st == 1].reshape(-1, 1, 2)
            # if we have lost too many features - re-pick them
            tracked_cnt = self._tracked_feature_count()
            if (
                tracked_cnt <= (self.initial_tracked_feature_count // 2)
                or tracked_cnt < 3
            ):
                user_p = self.user_point()
                self._pick_tracked_features(gr_frame, user_p.x, user_p.y)

            up_moved_by: typ.Vector = old_up - self.user_point()
            if up_moved_by.len_sq() > 10**2:
                logger.error("Tracked point moved too much. Forgetting it.")
                self.forget_tracking()
        self.prev_gray_frame = gr_frame

    def user_point(self) -> typ.Point | None:
        if self.is_tracking():
            user_point_poses = (
                self.tracked_features + self.feature_to_user_point_distances
            )
            avg_pos = np.average(user_point_poses, axis=(0, 1))
            assert avg_pos.shape == (2,)
            return typ.Point(x=avg_pos[0], y=avg_pos[1])
        return None

    def forget_tracking(self):
        self.tracked_features = None
        self.feature_to_user_point_distances = None

    def is_tracking(self) -> bool:
        return (
            self.tracked_features is not None
            and self.feature_to_user_point_distances is not None
        )

    def _pick_tracked_features(self, gr_frame: typ.VideoFrame, target_x, target_y):
        local_area_size = 50  # px
        min_y = max(0, target_y - local_area_size // 2)
        max_y = min_y + local_area_size
        min_x = max(0, target_x - local_area_size // 2)
        max_x = min_x + local_area_size
        sub_frame = gr_frame[min_y:max_y, min_x:max_x]
        local_tracked_features = cv2.goodFeaturesToTrack(
            sub_frame, mask=None, **self.feature_params
        )
        self.tracked_features = (
            local_tracked_features + np.array([min_x, min_y])
        ).astype(np.float32)
        self.feature_to_user_point_distances = (
            np.array([target_x, target_y]) - self.tracked_features
        )
        self.initial_tracked_feature_count = self._tracked_feature_count()

    def set_interesting_point(self, x, y):
        self._pick_tracked_features(self.prev_gray_frame, x, y)

    def draw_ui_overlay(self, frame: typ.VideoFrame) -> typ.VideoFrame:
        if up := self.user_point():
            # is tracking
            for group in self.tracked_features:
                for x, y in group:
                    frame = cv2.circle(
                        frame,
                        center=(int(x), int(y)),
                        radius=2,
                        color=(0, 50, 50),
                        thickness=2,
                    )
            # draw user point
            frame = cv2.circle(
                frame,
                center=(int(up.x), int(up.y)),
                radius=3,
                color=(100, 255, 150),
                thickness=4,
            )
        return frame

    def _tracked_feature_count(self) -> int:
        (rows, groups, coords) = self.tracked_features.shape
        assert coords == 2
        return rows * groups
