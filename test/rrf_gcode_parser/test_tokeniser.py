import io

import pytest
import rrf_gcode_parser


@pytest.mark.parametrize(
    "inp, out_tokens",
    [
        ("", []),
        ("G10", ["G10"]),
        ("G10 S1", ["G10", " ", "S1"]),
        ("G1     X100  Y12.3", ["G1", "     ", "X100", "  ", "Y12.3"]),
        ("G10 ; comment", ["G10", " ", ";", " ", "comment"]),
        ("G1;comment", ["G1", ";", "comment"]),
        ("G1; comment\nG12", ["G1", ";", " ", "comment", "\n", "G12"]),
        (
            "G10;comment   \n    G112",
            ["G10", ";", "comment", "   ", "\n", "    ", "G112"],
        ),
        ('M98 P"/sys/usr/brush.g"', ["M98", " ", 'P"/sys/usr/brush.g"']),
        ('M98 P"/file spaces.g"', ["M98", " ", 'P"/file spaces.g"']),
        ('M98 P"/file "".g"', ["M98", " ", 'P"/file "".g"']),
        ('M98 P"; ; "" ;;.g"', ["M98", " ", 'P"; ; "" ;;.g"']),
        (
            "; comment1\nG12 X42\n;comment2",
            [";", " ", "comment1", "\n", "G12", " ", "X42", "\n", ";", "comment2"],
        ),
    ],
)
def test_tokeniser(inp, out_tokens):
    out = list(rrf_gcode_parser.tokeniser.tokenise(io.StringIO(inp)))
    assert out == out_tokens
