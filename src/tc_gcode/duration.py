"""API to extract print duration"""
import dataclasses
import re
import typing

import numpy as np

import tc_gcode


@dataclasses.dataclass(frozen=True, kw_only=True)
class M73:
    lineno: int
    remaining_min: int


class PrintDurationModel:
    """A model that maps line numbers to print times and vice versa (print times to line numbers)"""

    times: tuple[M73]
    _const: float
    _lineno_coef: float

    def __init__(self, known_times: typing.Iterable[M73]):
        self.times = tuple(sorted(known_times, key=lambda m73: m73.lineno))
        self._compute_model()

    def _compute_model(self):
        """Prepare all model weights for use"""
        lines = [el.lineno for el in self.times]
        remaining_minutes = [el.remaining_min for el in self.times]
        # Convert "remaining minutes" to "print time"
        max_time = max(remaining_minutes)
        minutes = [max_time - rem_time for rem_time in remaining_minutes]
        seconds = [el * 60 for el in minutes]

        lines_arr = np.array(lines)
        seconds_arr = np.array(seconds)
        A = np.vstack([lines_arr, np.ones(len(lines_arr))]).T
        self._lineno_coef, self._const = np.linalg.lstsq(A, seconds_arr, rcond=None)[0]

    def get_time(self, lineno: int) -> float:
        """Returns estimated print second for the line"""
        return self._const + (lineno * self._lineno_coef)

    def get_lineno(self, time: float) -> int:
        """Returns estimated line for the given print second"""
        float_line = (time - self._const) / self._lineno_coef
        return int(np.floor(float_line))


def parse_m73(line: str) -> int | None:
    match = re.match(r"\s*M73.*\sR(\d+)", line.split(";")[0].strip(), re.I)
    if match:
        remain = match.group(1)
        return int(remain)


def get_model(input: "tc_gcode.typ.LineReader") -> PrintDurationModel:
    data: list[M73] = []
    last_remaining = None
    for lineno, line in input():
        line = line.strip()
        if (remaining_time := parse_m73(line)) is not None:
            m73 = M73(lineno=lineno, remaining_min=remaining_time)
            if last_remaining != m73.remaining_min:
                data.append(m73)
                last_remaining = m73.remaining_min

    return PrintDurationModel(data)
