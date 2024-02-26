import typing

import rrf_gcode_parser

LineReader = typing.Callable[
    [], typing.Iterable[rrf_gcode_parser.COMMAND]
]  # A callable that returns an iterable of (lineno, string)
