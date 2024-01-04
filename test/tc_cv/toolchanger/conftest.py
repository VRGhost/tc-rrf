import json
import pathlib

import pytest


@pytest.fixture
def resources_dir():
    return (pathlib.Path(__file__).parent / "resources").resolve()


@pytest.fixture
def mock_duet_api(mock_duet_api, resources_dir):
    def _mock_get_model(key: str):
        if key == "tools":
            with (resources_dir / "tools.json").open() as fin:
                return json.load(fin)["result"]
        elif key == "state":
            with (resources_dir / "state.json").open() as fin:
                return json.load(fin)["result"]
        else:
            raise NotImplementedError(key)

    with (resources_dir / "coords.json").open() as fin:
        mock_duet_api.get_coords.return_value = json.load(fin)

    mock_duet_api.get_model.side_effect = _mock_get_model
    return mock_duet_api
