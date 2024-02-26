import io

import pytest
import rrf_gcode_parser

Token = rrf_gcode_parser.tokeniser.Token


def test_empty():
    assert list(rrf_gcode_parser.tokeniser.tokenise(io.StringIO(""))) == []


@pytest.mark.parametrize(
    "inp, out_tokens",
    [
        ("G10", ["G10"]),
        ("G10 S1", ["G10", " ", "S1"]),
        ("G1     X100  Y12.3", ["G1", "     ", "X100", "  ", "Y12.3"]),
        ("G10 ; comment", ["G10", " ", ";", " ", "comment"]),
        ("G1;comment", ["G1", ";", "comment"]),
        ('M98 P"/sys/usr/brush.g"', ["M98", " ", 'P"/sys/usr/brush.g"']),
        ('M98 P"/file spaces.g"', ["M98", " ", 'P"/file spaces.g"']),
        ('M98 P"/file "".g"', ["M98", " ", 'P"/file "".g"']),
        ('M98 P"; ; "" ;;.g"', ["M98", " ", 'P"; ; "" ;;.g"']),
    ],
)
def test_tokeniser(inp, out_tokens):
    out = list(rrf_gcode_parser.tokeniser.tokenise(io.StringIO(inp)))
    assert out == [Token(el, lineno=0) for el in out_tokens]


def test_multiline_1():
    out = list(
        rrf_gcode_parser.tokeniser.tokenise(io.StringIO("G10;comment   \n    G112"))
    )
    assert out == [
        Token("G10", lineno=0),
        Token(";", lineno=0),
        Token("comment", lineno=0),
        Token("   ", lineno=0),
        Token("\n", lineno=0),
        Token("    ", lineno=1),
        Token("G112", lineno=1),
    ]


def test_multiline_2():
    out = list(
        rrf_gcode_parser.tokeniser.tokenise(
            io.StringIO("; comment1\nG12 X42\n;comment2")
        )
    )
    assert out == [
        Token(";", lineno=0),
        Token(" ", lineno=0),
        Token("comment1", lineno=0),
        Token(val="\n", lineno=0),
        Token(val="G12", lineno=1),
        Token(val=" ", lineno=1),
        Token(val="X42", lineno=1),
        Token(val="\n", lineno=1),
        Token(val=";", lineno=2),
        Token(val="comment2", lineno=2),
    ]


def test_multiline_3():
    out = list(rrf_gcode_parser.tokeniser.tokenise(io.StringIO("G1; comment\nG12")))
    assert out == [
        Token("G1", lineno=0),
        Token(val=";", lineno=0),
        Token(val=" ", lineno=0),
        Token(val="comment", lineno=0),
        Token(val="\n", lineno=0),
        Token(val="G12", lineno=1),
    ]
