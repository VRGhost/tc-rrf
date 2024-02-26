import io

import pytest
import rrf_gcode_parser


@pytest.fixture
def parse():
    def _parse(text: str) -> list[rrf_gcode_parser.gcode.COMMAND]:
        return list(rrf_gcode_parser.parser.parse(io.StringIO(text)))

    return _parse


def test_simple(parse):
    assert parse("") == []


def test_temp_block(parse):
    commands = parse(
        R"""
            G999 X1 ; comment
            m998 Y1 ; comment 2
            G1 X{param.S}
        """
    )
    assert len(commands) == 5
    assert isinstance(commands[0], rrf_gcode_parser.gcode.EmptyLine)
    assert commands[1].command == "G999"
    assert commands[2].command == "M998"
    x = commands[3].args["X"]
    assert x.orig_val == "{param.S}"


@pytest.mark.parametrize(
    "inp, exp_out",
    [
        ("M116", "M116"),
        ("G999 X1    Y2 ; comment", "G999 X1 Y2 ; comment"),
    ],
)
def test_m116(parse, inp, exp_out):
    commands = parse(inp)
    assert len(commands) == 1
    assert commands[0].to_gcode() == exp_out


@pytest.mark.parametrize(
    "typ, exp_val, change_to, exp_gcode",
    [
        (int, 1, 42, "G999 C2 A42 B2"),
        (float, 1.0, 1.2399, "G999 C2 A1.2399 B2"),
        (str, "1", "hello world", 'G999 C2 A"hello world" B2'),
    ],
)
def test_int_arg(parse, typ, exp_val, change_to, exp_gcode):
    commands = parse("G999 C2 A1 B2")
    assert len(commands) == 1
    cmd = commands[0]
    assert cmd.get("A", typ) == exp_val
    cmd.set("A", typ, change_to)
    assert cmd.to_gcode() == exp_gcode


@pytest.mark.parametrize(
    "typ, exp_val, change_to, exp_gcode",
    [
        (int, "2.3", 42, "G999 A42"),
        (float, 2.3, 1.2399, "G999 A1.2399"),
        (str, "2.3", "hello world", 'G999 A"hello world"'),
    ],
)
def test_float_arg(parse, typ, exp_val, change_to, exp_gcode):
    commands = parse("G999 A2.3")
    assert len(commands) == 1
    cmd = commands[0]
    assert cmd.get("A", typ) == exp_val
    cmd.set("A", typ, change_to)
    assert cmd.to_gcode() == exp_gcode


@pytest.mark.parametrize(
    "typ, exp_val, change_to, exp_gcode",
    [
        (int, '"hello""world"', 42, "G999 A42"),
        (float, '"hello""world"', 1.2399, "G999 A1.2399"),
        (str, 'hello"world', '-"-', 'G999 A"-""-"'),
    ],
)
def test_str_arg(parse, typ, exp_val, change_to, exp_gcode):
    commands = parse("""G999 A"hello""world" """)
    assert len(commands) == 1
    cmd = commands[0]
    assert cmd.get("A", typ) == exp_val
    cmd.set("A", typ, change_to)
    assert cmd.to_gcode() == exp_gcode
