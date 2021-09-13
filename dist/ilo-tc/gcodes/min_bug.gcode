
if 1 < 2
    var outer_idx = 0

    while var.outer_idx < 50
        G0 X0 Y0 F50000
        if mod(var.outer_idx, 5) == 3
            G0 X20 Y20
            abort "boo"
            M98 P"/gcodes/min_bug_fn.gcode" T1
        else
            G0 X10 Y10
            M98 P"/gcodes/min_bug_fn.gcode" T0

        G0 X100 Y100 F50000
        set var.outer_idx = var.outer_idx + 1
