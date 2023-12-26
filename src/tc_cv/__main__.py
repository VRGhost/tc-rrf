import asyncio
import logging

import cv2
import duetwebapi
import typer

import tc_cv

cli_app = typer.Typer()


@cli_app.command()
def xy_offset(
    video_source: str = "udp://ppi.hoopoe:1234", dwt: str = "http://dwc.hoopoe"
):
    printer = duetwebapi.DuetWebAPI(dwt)
    printer.connect(password="")
    vcap = cv2.VideoCapture(f"{video_source}?fifo_size=1000000")
    configurator = tc_cv.xy_config.XYConfigurator(vcap, printer)
    asyncio.run(configurator.run())


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    cli_app()
