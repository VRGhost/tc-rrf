import operator
from functools import reduce
from io import BytesIO, StringIO, TextIOWrapper
from typing import Dict, List, Union

import requests

from .base import DuetAPI


class DSFAPI(DuetAPI):
    """
    Duet Software Framework REST API Interface.

    Used with a Duet 3 + SBC.
    Must use RRF3.
    """

    api_name = "DSF_REST"

    def get_model(self, key: str = None, **kwargs) -> Dict:
        url = f"{self.base_url}/machine/status"
        r = requests.get(url)
        j = r.json()
        if key is not None:
            keys = key.split(".")
            return reduce(operator.getitem, keys, j)
        return j

    def send_code(self, code: str) -> Dict:
        url = f"{self.base_url}/machine/code"
        r = requests.post(url, data=code)
        return {"response": r.text}

    def get_file(
        self, filename: str, directory: str = "gcodes", binary: bool = False
    ) -> str:
        """
        filename: name of the file you want to download including extension
        directory: the folder that the file is in, options are ['gcodes', 'macros', 'sys']
        binary: return binary data instead of a string

        returns the file as a string or binary data
        """
        url = f"{self.base_url}/machine/file/{directory}/{filename}"
        r = requests.get(url)
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
        """
        file: the path to the file you want to upload from your PC
        directory: the folder that the file is in, options are ['gcodes', 'macros', 'sys']
        """
        url = f"{self.base_url}/machine/file/{directory}/{filename}"
        r = requests.put(
            url, data=file, headers={"Content-Type": "application/octet-stream"}
        )
        if not r.ok:
            raise ValueError
        return {"err": 0}

    def get_fileinfo(self, filename: str = None, directory: str = "gcodes") -> Dict:
        url = f"{self.base_url}/machine/fileinfo/{directory}/{filename}"
        r = requests.get(url)
        if not r.ok:
            raise ValueError
        return r.json()

    def delete_file(self, filename: str, directory: str = "gcodes") -> Dict:
        url = f"{self.base_url}/machine/file/{directory}/{filename}"
        r = requests.delete(url)
        if not r.ok:
            raise ValueError
        return {"err": 0}

    def move_file(self, from_path: str, to_path: str, force: bool = False) -> Dict:
        url = f"{self.base_url}/machine/file/move"
        r = requests.post(
            url, {"from": f"{from_path}", "to": f"{to_path}", "force": force}
        )
        if not r.ok:
            raise ValueError
        return {"err": 0}

    def get_directory(self, directory: str) -> List[Dict]:
        url = f"{self.base_url}/machine/directory/{directory}"
        r = requests.get(url)
        if not r.ok:
            raise ValueError
        return r.json()

    def create_directory(self, directory: str) -> Dict:
        url = f"{self.base_url}/machine/directory/{directory}"
        r = requests.put(url)
        if not r.ok:
            raise ValueError
        return {"err": 0}
