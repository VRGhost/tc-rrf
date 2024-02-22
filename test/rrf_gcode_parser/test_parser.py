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
    assert len(commands) == 4
    assert isinstance(commands[0], rrf_gcode_parser.gcode.EmptyLine)
    assert commands[1].command == "G999"
    assert commands[2].command == "M998"
    assert commands[3].args == ["X{PARAM.S}"]
