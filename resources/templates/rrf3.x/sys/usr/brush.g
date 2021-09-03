{% from '/__macros__/axes.jinja' import set_mov_axis_id -%}
{% from "__macros__/move.jinja" import avoid_tc_clash -%}

{{ avoid_tc_clash()}}

{{ set_mov_axis_id('x_idx', 'X') }}

var tool_x_offset = 0
if state.currentTool >= 0
    set var.tool_x_offset = tools[state.currentTool].offsets[var.x_idx]

if var.tool_x_offset >= 0
    M98 P"/sys/usr/brushes/right.g"
else
    M98 P"/sys/usr/brushes/left.g"

{% from 'sys/usr/maybe_brush.g' import update_maybe_brush_timestamp %}

{{ update_maybe_brush_timestamp() }}