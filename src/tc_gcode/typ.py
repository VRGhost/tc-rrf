import typing

LineToTimeFn = typing.Callable[[int], float]
LineReader = typing.Callable[
    [], typing.Iterable[tuple[int, str]]
]  # A callable that returns an iterable of (lineno, string)
