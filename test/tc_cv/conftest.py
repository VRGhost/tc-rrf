import pytest


@pytest.fixture
def mock_duet_api(mocker):
    return mocker.MagicMock(name="mock_duet_api")
