import pytest

import tc_cv.toolchanger.gcode


@pytest.fixture
def gcode(mock_duet_api):
    return tc_cv.toolchanger.gcode.GCode(mock_duet_api)


def test_tmp_settings(mock_duet_api, gcode):
    with gcode.tmp_settings():
        gcode.send("TEST_COMMAND_1")
        gcode.send("TEST_COMMAND_2")

    assert [cmd.args for cmd in mock_duet_api.send_code.mock_calls] == [
        ("M120",),
        ("TEST_COMMAND_1",),
        ("TEST_COMMAND_2",),
        ("M121",),
    ]


def test_restore_pos(mock_duet_api, gcode):
    with gcode.restore_pos():
        gcode.send("TEST_COMMAND_1")
        gcode.send("TEST_COMMAND_2")

    assert [cmd.args for cmd in mock_duet_api.send_code.mock_calls] == [
        ("TEST_COMMAND_1",),
        ("TEST_COMMAND_2",),
        ("G0 X149.781 Y96.551 Z195.0",),
    ]
