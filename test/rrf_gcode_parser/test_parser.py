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
    assert x.orig_val == "{PARAM.S}"


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
