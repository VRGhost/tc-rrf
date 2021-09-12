; This script maybe calls brush (if it hadn't been called too long ago)
; This is meant to be called periodically while printing

{% macro declare_global_maybe_brush_vars() -%}
; ---- see /sys/usr/maybe_brush.g
global maybe_brush_last_tool = -100
global maybe_brush_last_time = -99999
{% endmacro -%}

{% macro update_maybe_brush_timestamp() -%}
; ---- update_maybe_brush_timestamp
set global.maybe_brush_last_tool = state.currentTool
set global.maybe_brush_last_time = state.upTime
{% endmacro %}




{% set max_brush_freq_secs = 300 -%}


if global.maybe_brush_last_tool != state.currentTool || (global.maybe_brush_last_time + {{ max_brush_freq_secs }}) < state.upTime
    G10 ; retract
    G91
    G1 Z10
    G90

    M98 P"/sys/usr/brush.g"

    G91
    G1 Z-10
    G90
    G11 ; unretract
else
    echo "maybe_brush.g: skip"
