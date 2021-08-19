; Bed Mesh Leveling (G32 command)

; This macro saves and restores currently used tool






var c_axis_2 = -1
var old_tool_3 = -1

;----- find_axis_id("C", var.c_axis_2)

var axis_iter_4 = 0
var find_success_5 = 0 ; 0 - not found, 1 - found

while var.axis_iter_4 < #move.axes
    if move.axes[var.axis_iter_4].letter == "C"
        set var.find_success_5 = 1
        set var.c_axis_2 = var.axis_iter_4
        break
    set var.axis_iter_4 = var.axis_iter_4 + 1

if var.find_success_5 == 0
    abort "Failed to find C axis"

;----- find_axis_id("C", var.c_axis_2) END

if !move.axes[var.c_axis_2].homed
    abort "Coupler (C) is not homed."


set var.old_tool_3 = state.currentTool
T-1



G29



T{ var.old_tool_3 }
