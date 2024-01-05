import logging
import time
from io import BytesIO, StringIO, TextIOWrapper
from typing import Dict, List, Union

import requests

from .base import DuetAPI

logger = logging.getLogger(__name__)


class DWCAPI(DuetAPI):
    """
    Duet Web Control REST API Interface.

    Used with a Duet 2/3 in standalone mode.
    Must use RRF3.
    """

    api_name = "DWC_REST"
    retry_count: int = 5

    def connect(self, password=""):
        """Start connection to Duet"""
        url = f"{self.base_url}/rr_connect"
        r = requests.get(url, {"password": password})
        if not r.ok:
            raise ValueError
        return r.json()

    def disconnect(self):
        """End connection to Duet"""
        url = f"{self.base_url}/rr_disconnect"
        r = requests.get(url)
        if not r.ok:
            raise ValueError
        return r.json()

    def _retry_gen(self):
        for retry_idx in range(self.retry_count):
            time.sleep(retry_idx)
            yield

    def get_model(
        self,
        key: str = None,
        depth: int = 99,
        verbose: bool = True,
        null: bool = True,
        frequent: bool = False,
        obsolete: bool = False,
    ) -> Dict:
        url = f"{self.base_url}/rr_model"
        flags = f"d{depth}"
        flags += "v" if verbose is True else ""
        flags += "n" if null is True else ""
        flags += "f" if frequent is True else ""
        flags += "o" if obsolete is True else ""
        for _try in self._retry_gen():
            r = requests.get(url, {"flags": flags, "key": key})
            if r.status_code >= 500 and r.status_code < 600:
                # Server-side error => retry
                continue
            else:
                break
        if not r.ok:
            logger.error(f"Model error response: {r.text!r}")
            raise ValueError(r.text)
        j = r.json()
        return j["result"]

    def _get_reply(self) -> Dict:
        url = f"{self.base_url}/rr_reply"
        r = requests.get(url)
        if not r.ok:
            raise ValueError
        return r.text

    def send_code(self, code: str) -> Dict:
        url = f"{self.base_url}/rr_gcode"
        if len(code) > 160:  # Max line lenght per dwc
            lines = [line.strip() for line in code.splitlines() if line.strip()]
        else:
            lines = [code]
        response_lines = []
        buf_available = 9999
        for line in lines:
            assert len(line) < 160
            while len(line) > buf_available:
                time.sleep(0.5)
                resp = requests.get(url, {"gcode": ""})
                assert resp.ok
                data = resp.json()
                assert data.get("err", 0) == 0
                buf_available = data["buff"]
            resp = requests.get(url, {"gcode": line})
            if not resp.ok:
                raise ValueError(line)
            data = resp.json()
            if data.get("err", 0) != 0:
                raise ValueError(line)

            buf_available = data["buff"]
            response_lines.append(self._get_reply())
        return {"response": "\n".join(response_lines)}

    def get_file(
        self, filename: str, directory: str = "gcodes", binary: bool = False
    ) -> str:
        """
        filename: name of the file you want to download including extension
        directory: the folder that the file is in, options are ['gcodes', 'macros', 'sys']
        binary: return binary data instead of a string

        returns the file as a string or binary data
        """
        url = f"{self.base_url}/rr_download"
        r = requests.get(url, {"name": f"/{directory}/{filename}"})
        if not r.ok:
            raise ValueError
        if binary:
            return r.content
        else:
            return r.text

    def upload_file(
        self,
        file: Union[str, bytes, StringIO, TextIOWrapper, BytesIO],
        filename: str,
        directory: str = "gcodes",
    ) -> Dict:
        url = f"{self.base_url}/rr_upload?name=/{directory}/{filename}"
        r = requests.post(url, data=file)
        if not r.ok:
            raise ValueError
        return r.json()

    def get_fileinfo(self, filename: str = None, directory: str = "gcodes") -> Dict:
        url = f"{self.base_url}/rr_fileinfo"
        if filename:
            r = requests.get(url, {"name": f"/{directory}/{filename}"})
        else:
            r = requests.get(url)
        if not r.ok:
            raise ValueError
        return r.json()

    def delete_file(self, filename: str, directory: str = "gcodes") -> Dict:
        url = f"{self.base_url}/rr_delete"
        r = requests.get(url, {"name": f"/{directory}/{filename}"})
        if not r.ok:
            raise ValueError
        return r.json()

    def move_file(self, from_path, to_path, **_ignored):
        # BUG this doesn't work currently
        raise NotImplementedError
        url = f"{self.base_url}/rr_move"
        r = requests.get(url, {"old": f"{from_path}", "new": f"{to_path}"})
        if not r.ok:
            raise ValueError
        return r.json()

    def get_directory(self, directory: str) -> List[Dict]:
        url = f"{self.base_url}/rr_filelist"
        r = requests.get(url, {"dir": f"/{directory}"})
        if not r.ok:
            raise ValueError
        return r.json()["files"]

    def create_directory(self, directory: str) -> Dict:
        url = f"{self.base_url}/rr_mkdir"
        r = requests.get(url, {"dir": f"/{directory}"})
        if not r.ok:
            raise ValueError
        return r.json()
