"""This tracker detects motion in the video stream"""

import asyncio
import logging

import cv2
import numpy as np

from .. import typ

logger = logging.getLogger(__name__)


class Odometer:
    """This class estimates the amount of movement happening in the video."""

    feature_params = {  # Parameters for lucas kanade optical flow
        "maxCorners": 12,  # how many pts. to locate
        "qualityLevel": 0.3,  # b/w 0 & 1, min. quality below which everyone is rejected
        "minDistance": 7,  # min eucledian distance b/w corners detected
        "blockSize": 10,
    }

    lk_params = {
        "winSize": (15, 15),  # size of the search window at each pyramid level
        "maxLevel": 2,  #  0, pyramids are not used (single level), if set to 1, two levels are used, and so on
        "criteria": (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03),
    }

    tracked_features: np.ndarray = None
    initial_tracked_feature_count: int = None
    prev_gray_frame: typ.VideoFrame = None
    np_odometer: int  # sum of squares of all changes

    def __init__(self):
        self.np_odometer = 0

    def _tracked_feature_count(self) -> int:
        (rows, groups, coords) = self.tracked_features.shape
        assert coords == 2
        return rows * groups

    def _pick_tracked_features(self, gr_frame: typ.VideoFrame):
        self.tracked_features = cv2.goodFeaturesToTrack(
            gr_frame, mask=None, **self.feature_params
        )
        self.initial_tracked_feature_count = self._tracked_feature_count()

    def _update_odometer(self, old_features, new_features):
        assert old_features.shape == new_features.shape, (
            old_features.shape,
            new_features.shape,
        )
        diff = np.subtract(old_features, new_features)
        change = np.average(diff, axis=0)
        change = np.square(change)
        if np.any(change > 1):
            self.np_odometer += np.sum(change)

    def push(self, frame: typ.VideoFrame):
        gr_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        if self.tracked_features is None:
            self._pick_tracked_features(gr_frame)
        else:
            new_points, st, err = cv2.calcOpticalFlowPyrLK(
                self.prev_gray_frame,
                gr_frame,
                self.tracked_features,
                None,
                **self.lk_params
            )
            old_tracked_features = self.tracked_features[st == 1]
            new_tracked_features = new_points[st == 1]
            self._update_odometer(old_tracked_features, new_tracked_features)
            self.tracked_features = new_tracked_features.reshape(-1, 1, 2)
            # if we have lost too many features - re-pick them
            tracked_cnt = self._tracked_feature_count()
            if (
                tracked_cnt <= (self.initial_tracked_feature_count // 2)
                or tracked_cnt < 3
            ):
                self._pick_tracked_features(gr_frame)
        self.prev_gray_frame = gr_frame

    def draw_ui_overlay(self, frame: typ.VideoFrame) -> typ.VideoFrame:
        if self.tracked_features is not None:
            for group in self.tracked_features:
                for x, y in group:
                    frame = cv2.circle(
                        frame,
                        center=(int(x), int(y)),
                        radius=2,
                        color=(255, 0, 100),
                        thickness=2,
                    )
        return frame

    async def wait_for_motion_to_start(self):
        exp_val = self.np_odometer + 3
        while self.np_odometer < exp_val:
            # logging.debug(f"wait_for_motion_to_start {self.np_odometer=} {exp_val=}")
            await asyncio.sleep(0.2)

    async def wait_for_motion_to_stop(self):
        epsilon = 2  # Ignore any changes of below 2 px
        start_val = self.np_odometer
        new_val = start_val + 100 + 10 * epsilon
        while (start_val - new_val) > epsilon:  # While there is too much movement
            await asyncio.sleep(0.5)
            new_val = self.np_odometer
            # logging.debug(f"wait_for_odometer_increase {new_val=} {start_val=}")
