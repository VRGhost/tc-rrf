; This script maybe calls brush (if it hadn't been called too long ago)
; This is meant to be called periodically while printing

{% set max_brush_freq_secs = 30 -%}


if global.maybe_brush_last_tool != state.currentTool || (global.maybe_brush_last_time + {{ max_brush_freq_secs }}) < state.upTime
    G91
    G1 Z10
    G90

    M98 P"/sys/usr/brush.g"

    G91
    G1 Z-10
    G90

    set global.maybe_brush_last_tool = state.currentTool
    set global.maybe_brush_last_time = state.upTime
else
    echo "maybe_brush.g: skip"
