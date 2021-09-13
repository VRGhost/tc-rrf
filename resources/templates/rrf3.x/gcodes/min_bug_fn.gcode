; param.T - boolean controlling if the manhattan move gets triggered or not.

var inner_idx = 0

while var.inner_idx < 10
    G0 X0 Y0 F50000
    if param.T > 0 && mod(var.inner_idx, 3) == 2
        M98 P"/sys/usr/lib/manhattan_move.g" X10 Y10 Z0 F50000
    G1 X100 Y 100

    if param.T > 0 && mod(var.inner_idx, 3) == 2
        M98 P"/sys/usr/lib/manhattan_move.g" X180 Y180 Z0 F50000

    G0 X100 Y100 F50000
    set var.inner_idx = var.inner_idx + 1