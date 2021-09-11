if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


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
