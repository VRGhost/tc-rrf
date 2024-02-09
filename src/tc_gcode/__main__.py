import dataclasses
import logging
import pathlib
import re
import typing

import numpy as np
import typer

import tc_gcode

cli_app = typer.Typer()


@dataclasses.dataclass(frozen=True, kw_only=True)
class M73:
    remaining_min: int


def parse_m73(line: str) -> M73 | None:
    match = re.match(r"\s*M73.*\sR(\d+)", line.split(";")[0].strip(), re.I)
    if match:
        remain = match.group(1)
        return M73(remaining_min=int(remain))


def get_time_func(input: tc_gcode.typ.LineReader) -> tc_gcode.typ.LineToTimeFn:
    data: dict[int, int] = {}  # lineno -> remaning_min
    last_remaining = None
    for lineno, line in input():
        line = line.strip()
        if m73 := parse_m73(line):
            if last_remaining != m73.remaining_min:
                data[lineno] = m73.remaining_min
                last_remaining = m73.remaining_min

    lines = sorted(data.keys())
    minutes = [data[key] for key in lines]

    lines_arr = np.array(lines)
    minutes_arr = np.array(minutes)
    A = np.vstack([lines_arr, np.ones(len(lines_arr))]).T
    m, c = np.linalg.lstsq(A, minutes_arr, rcond=None)[0]
    return lambda lineno: m * lineno + c


def insert_preheats(
    input: tc_gcode.typ.LineReader,
    tc: tc_gcode.toolchanges.ProjectToolchanges,
    time_fn:  tc_gcode.typ.LineReader,
    preheat_time: float,
) -> typing.Iterable[str]:
    first_tc_seen: bool = False
    off_tools = set()
    hot_tools = set()
    for lineno, line in input():
        time_remaining = time_fn(lineno)

        if parse_m73(line):
            continue  # Do not output m73s

        cur_tool = tc.get_current_tool(lineno)
        future_tool = tc.get_tool_used_at(time_remaining - preheat_time)
        if cur_tool != future_tool and cur_tool is not None and future_tool not in hot_tools:
            print(future_tool)
            hot_tools.add(future_tool)
        yield line


def mk_reader(input: pathlib.Path) -> tc_gcode.typ.LineReader:
    def _reader():
        with input.open("r") as fin:
            yield from enumerate(fin.readlines())

    return _reader


@cli_app.command()
def process(
    input: pathlib.Path,
    start_preheating_at: typing.Annotated[
        float,
        typer.Argument(help="How many minutes in advance to start tool preheating"),
    ] = 3.0,
):
    reader = mk_reader(input)
    fn = get_time_func(reader)
    toolchanges = tc_gcode.toolchanges.get_toolchanges(reader, fn)
    for _line in insert_preheats(reader, toolchanges, fn, start_preheating_at):
        pass


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    cli_app()
