import logging
import pathlib
import typing

import typer
from typing_extensions import Annotated

import tc_rrf

PROJ_DIR = pathlib.Path(__file__).parent.parent.parent.resolve()
TEMPLATES_ROOT = PROJ_DIR / "resources" / "templates"
OUTPUT_ROOT = PROJ_DIR / "dist"

cli_app = typer.Typer()


@cli_app.command()
def render(
    index: pathlib.Path = (PROJ_DIR / "resources" / "ilo-tc.yaml"),
    templates_dir: pathlib.Path = TEMPLATES_ROOT,
    out_dir: pathlib.Path = OUTPUT_ROOT,
):
    tc_rrf.render.main(index, templates_dir, out_dir)


@cli_app.command()
def upload(
    host: Annotated[
        typing.Optional[str],
        typer.Argument(help='Duet Web Console (DWC) url. E.g "http://192.168.242.45"'),
    ],
    index: pathlib.Path = (PROJ_DIR / "resources" / "ilo-tc.yaml"),
    password: Annotated[
        typing.Optional[str], typer.Argument(help="DWC password")
    ] = None,
    out_dir: pathlib.Path = OUTPUT_ROOT,
):
    tc_rrf.upload.main(index, out_dir, host, password)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    cli_app()
