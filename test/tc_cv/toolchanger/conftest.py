import json
import pathlib

import pytest


@pytest.fixture
def resources_dir():
    return (pathlib.Path(__file__).parent / "resources").resolve()


@pytest.fixture
def mock_duet_api(mock_duet_api, resources_dir):
    def _mock_get_model(key: str):
        fname = {
            "tools": "tools.json",
            "state": "state.json",
            "move.axes": "move_axes.json",
        }.get(key, None)
        if fname is None:
            raise NotImplementedError(key)
        else:
            with (resources_dir / fname).open() as fin:
                return json.load(fin)["result"]

    with (resources_dir / "coords.json").open() as fin:
        mock_duet_api.get_coords.return_value = json.load(fin)

    mock_duet_api.get_model.side_effect = _mock_get_model
    return mock_duet_api
