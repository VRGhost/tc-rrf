import dataclasses
import re
import typing

TOKEN_END_RE = re.compile(
    r"""
        (?:[ \t]+) |
        ; |
        \n
    """,
    re.VERBOSE,
)
NOT_TOKEN_RE = re.compile(
    r"""
        "(?:[^"]|"")*"
    """,
    re.VERBOSE,
)
READ_BLOCK_SIZE = 2**11


def _find_next_token_end(text: str) -> re.Match | None:
    maybe_split = TOKEN_END_RE.search(text)
    not_token = NOT_TOKEN_RE.search(text)
    if not not_token:
        return maybe_split  # No 'not tokens' detected
    elif not maybe_split:
        return None  # No splits found
    assert not_token is not None
    assert maybe_split is not None
    if not_token.end() < maybe_split.start() or not_token.start() > maybe_split.end():
        # No overlap
        return maybe_split
    # Else - re-search
    return TOKEN_END_RE.search(text, pos=not_token.end())


@dataclasses.dataclass(frozen=True, slots=True)
class Token:
    val: str
    lineno: int


def tokenise(input: typing.IO[str]) -> typing.Generator[Token, None, None]:
    """Split input file to tokens"""
    input_text = ""
    input_open = True
    lineno = 0
    while input_open or input_text:
        if len(input_text) < 512:
            new_text = input.read(READ_BLOCK_SIZE)
            input_text += new_text
            input_open = new_text and (len(new_text) > 0)
        m = _find_next_token_end(input_text)
        if m:
            st = m.start()
            end = m.end()
            if st > 0:
                yield Token(input_text[:st], lineno)
            if st != end:
                tmp_lineno = lineno + input_text[:st].count("\n")
                yield Token(input_text[st:end], tmp_lineno)
            lineno += input_text[:end].count("\n")
            input_text = input_text[end:]
        else:
            # not found -> yield as single token
            if input_text:
                yield Token(input_text, lineno)
            input_text = ""
