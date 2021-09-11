; {'x_max': 328.5, 'width': 6, 'y_min': 128, 'depth': 33}





var src_x = move.axes[0].userPosition
var src_y = move.axes[1].userPosition
var on_the_bed = ( var.src_x >= 0 && var.src_y >= 0 && var.src_x <= 300 && var.src_y <= 200 )

if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


if var.on_the_bed
    

    ; ---- rel_move(None, None, 15, None, G0)
    G91
    G0 Z15
    G90
    ; ---- rel_move() END


; Go to the start of the brush
G0 X325.5 Y128 F50000

;M98 P"/sys/usr/lib/manhattan_move.g" X325.5 Y128 Z0 F50000

; Side-to-side motions

G1 X322.5 Y121.4 F50000
G1 X328.5 Y128.0 F50000

G1 X322.5 Y128.0 F50000
G1 X328.5 Y134.6 F50000

G1 X322.5 Y134.6 F50000
G1 X328.5 Y141.2 F50000

G1 X322.5 Y141.2 F50000
G1 X328.5 Y147.8 F50000

G1 X322.5 Y147.8 F50000
G1 X328.5 Y154.4 F50000


; Front-to-back motions

G1 X320.5 Y123 F50000
G1 X325.5 Y166 F50000

G1 X322.5 Y123 F50000
G1 X327.5 Y166 F50000

G1 X324.5 Y123 F50000
G1 X329.5 Y166 F50000

; Front-to-back end

; One last time to clear any debree off
G0 X325.5 Y128 F50000
G0 X325.5 Y191 F50000

if var.on_the_bed
    ; Return to the point of origin if it is on the bed
    M98 P"/sys/usr/lib/manhattan_move.g" X{var.src_x} Y{var.src_y} Z0 F50000
    

    ; ---- rel_move(None, None, -15, None, G0)
    G91
    G0 Z-15
    G90
    ; ---- rel_move() END


