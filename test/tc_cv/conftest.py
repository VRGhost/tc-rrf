import pytest


@pytest.fixture
def mock_duet_api(mocker):
    mock_api = mocker.MagicMock(name="mock_duet_api")
    mock_api.get_coords.return_value = {
        "X": 149.781,
        "Y": 96.551,
        "Z": 195.0,
        "A": 14.07,
        "B": 14.07,
        "C": 241.0,
    }
    return mock_api
