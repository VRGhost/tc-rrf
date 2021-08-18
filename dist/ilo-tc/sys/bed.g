; Bed Mesh Leveling (G32 command)

; This macro saves and restores currently used tool



var C_axis = -1




var axis_iter_0 = 0
var find_success_1 = 0 ; 0 - not found, 1 - found

while var.axis_iter_0 < #move.axes
    if move.axes[var.axis_iter_0].letter == "C"
        set var.find_success_1 = 1
        set var.C_axis = var.axis_iter_0
    set var.axis_iter_0 = var.axis_iter_0 + 1

if var.find_success_1 == 0
    abort "Failed to find C axis"

if move.axes[var.C_axis].homed && state.currentTool >= -10
    abort 'potato'



G29


