; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


var tool_x_offset = 0
if state.currentTool >= 0
    set var.tool_x_offset = tools[state.currentTool].offsets[0]

if var.tool_x_offset >= 0
    M98 P"/sys/usr/brushes/right.g"
else
    M98 P"/sys/usr/brushes/left.g"



; ---- update_maybe_brush_timestamp
set global.maybe_brush_last_tool = state.currentTool
set global.maybe_brush_last_time = state.upTime
