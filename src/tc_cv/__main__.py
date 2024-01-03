import asyncio
import logging
import os

import cv2
import duetwebapi
import typer

import tc_cv

logger = logging.getLogger(__name__)
cli_app = typer.Typer()


@cli_app.command()
def xy_offset(
    video_source: str = "udp://ppi.hoopoe:1234", dwt: str = "http://dwc.hoopoe"
):
    logger.info("hello world")
    printer = duetwebapi.DuetWebAPI(dwt)
    printer.connect(password="")
    os.environ["OPENCV_FFMPEG_CAPTURE_OPTIONS"] = "|".join(
        f"{key};{value}"
        for (key, value) in {
            "max_delay": 0,
            "max_probe_packets": 1,
            "flags": "+low_delay",
            "fflags": "+nobuffer",
            "framedrop": 1,
            "analyzeduration": 0,
            "probesize": 32,
            "sync": "ext",
        }.items()
    )
    os.environ |= {"OPENCV_FFMPEG_DEBUG": "1", "OPENCV_LOG_LEVEL": "VERBOSE"}
    vcap = cv2.VideoCapture(f"{video_source}", cv2.CAP_FFMPEG)
    vcap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
    configurator = tc_cv.xy_config.XYConfigurator(vcap, printer)
    asyncio.run(configurator.run())


@cli_app.callback()
def start_app():
    logging.basicConfig(level=logging.DEBUG)


if __name__ == "__main__":
    cli_app()
