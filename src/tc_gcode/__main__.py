import logging
import pathlib
import typing

import typer

import tc_gcode

cli_app = typer.Typer()


def mk_reader(input: pathlib.Path) -> tc_gcode.typ.LineReader:
    def _reader():
        with input.open("r") as fin:
            yield from enumerate(fin.readlines())

    return _reader


@cli_app.command()
def process(
    input: pathlib.Path,
    output: pathlib.Path,
    start_preheating_at: typing.Annotated[
        float,
        typer.Argument(help="How many minutes in advance to start tool preheating"),
    ] = 3.0,
):
    reader = mk_reader(input)
    duration_model = tc_gcode.duration.get_model(reader)
    toolchanges = tc_gcode.toolchanges.get_toolchanges(reader)
    with output.open("w") as fout:
        for line in tc_gcode.convert.convert(
            reader, toolchanges, duration_model, start_preheating_at * 60
        ):
            pass
            fout.write(line + "\n")


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    cli_app()
