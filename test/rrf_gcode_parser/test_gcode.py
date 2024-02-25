import io

import pytest
import rrf_gcode_parser


@pytest.fixture
def parse():
    def _parse(text: str) -> list[rrf_gcode_parser.gcode.COMMAND]:
        return list(rrf_gcode_parser.parser.parse(io.StringIO(text)))

    return _parse


def test_change_int_arg(parse):
    commands = parse("M116 P1")
    assert len(commands) == 1
    cmd = commands[0]
    assert cmd.P == 1
    cmd.P = 42
    assert cmd.P == 42
    assert cmd.to_gcode() == "M116 P42"


def test_change_int_arg_2(parse):
    commands = parse("M116 P1 H2")
    assert len(commands) == 1
    cmd = commands[0]
    cmd.P = 42
    cmd.H = 12
    assert cmd.to_gcode() == "M116 P42 H12"


def test_add_arg(parse):
    commands = parse("M116 P1")
    assert len(commands) == 1
    cmd = commands[0]
    cmd.H = 42
    assert cmd.to_gcode() == "M116 P1 H42"


def test_del_arg(parse):
    commands = parse("M116 P1 H2")
    assert len(commands) == 1
    cmd = commands[0]
    cmd.H = None
    assert cmd.to_gcode() == "M116 P1"
    del cmd.P
    assert cmd.to_gcode() == "M116"
    cmd.H = 42
    cmd.S = 1
    assert cmd.to_gcode() == "M116 H42 S1"


def test_float_arg(parse):
    commands = parse("M116")
    assert len(commands) == 1
    cmd = commands[0]
    assert cmd.get("A", float) is None
    cmd.set("A", float, 0.52)
    assert cmd.get("A", float) == 0.52
    assert cmd.to_gcode() == "M116 A0.52"
