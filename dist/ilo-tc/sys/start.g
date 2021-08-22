;---- Home if ANY axis is not homed

var do_home = false
var axis_idx = 0

while var.axis_idx < #move.axes
    if !move.axes[var.axis_idx].homed
        set var.do_home = true
        break
    set var.axis_idx = var.axis_idx + 1

if var.do_home
    echo "Some axes not homed. Homing."
    G28
