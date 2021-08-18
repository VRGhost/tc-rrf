; Bed Mesh Leveling (G32 command)

; This macro saves and restores currently used tool






var c_axis_0 = -1
var old_tool_1 = -1




var axis_iter_2 = 0
var find_success_3 = 0 ; 0 - not found, 1 - found

while var.axis_iter_2 < #move.axes
    if move.axes[var.axis_iter_2].letter == "C"
        set var.find_success_3 = 1
        set var.{{ c_axis }} = var.axis_iter_2
        break
    set var.axis_iter_2 = var.axis_iter_2 + 1

if var.find_success_3 == 0
    abort "Failed to find C axis"

if !move.axes[var.c_axis_0].homed
    abort "Coupler (C) is not homed."


set var.old_tool_1 = state.currentTool
T-1



G29



T{ var.old_tool_1 }
