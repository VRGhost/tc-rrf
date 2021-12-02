; {'x_max': 328.5, 'width': 6, 'y_min': 128, 'depth': 33}





if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


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


