import datetime

import pytest

import tc_cv


@pytest.fixture
def toolchanger(resources_dir, mock_duet_api):
    return tc_cv.toolchanger.Toolchanger(mock_duet_api)


def test_get_printer_coords(toolchanger):
    assert toolchanger.get_coords() == tc_cv.typ.Point(x=149.781, y=96.551, z=195.0)


def test_get_tools(toolchanger):
    tools = toolchanger.get_tools()
    assert [tool.name for tool in tools] == ["T0", "T1", "T2", "T3"]
    assert [tool.active for tool in tools] == [False, False, False, True]


def test_get_state(toolchanger):
    assert toolchanger.get_state() == tc_cv.toolchanger.toolchanger.State(
        currentTool=-1,
        msUpTime=198,
        status="idle",
        time=datetime.datetime(2024, 1, 4, 22, 9, 37),
        upTime=4634,
    )


def test_get_axes_info(toolchanger):
    info = toolchanger.get_axes_info()
    assert [el.letter for el in info] == ["X", "Y", "Z", "A", "B", "C"]
