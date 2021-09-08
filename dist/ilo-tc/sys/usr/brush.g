; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed


var x_idx = -1
;----- find_axis_id("X", var.x_idx)

var axis_iter_10 = 0
var find_success_11 = 0 ; 0 - not found, 1 - found

while var.axis_iter_10 < #move.axes
    if move.axes[var.axis_iter_10].letter == "X"
        set var.find_success_11 = 1
        set var.x_idx = var.axis_iter_10
        break
    set var.axis_iter_10 = var.axis_iter_10 + 1

if var.find_success_11 == 0
    abort "Failed to find X axis"

;----- find_axis_id("X", var.x_idx) END

var tool_x_offset = 0
if state.currentTool >= 0
    set var.tool_x_offset = tools[state.currentTool].offsets[var.x_idx]

if var.tool_x_offset >= 0
    M98 P"/sys/usr/brushes/right.g"
else
    M98 P"/sys/usr/brushes/left.g"



; ---- update_maybe_brush_timestamp
set global.maybe_brush_last_tool = state.currentTool
set global.maybe_brush_last_time = state.upTime
