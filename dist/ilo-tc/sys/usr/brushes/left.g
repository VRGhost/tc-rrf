; {'x_max': -19, 'width': 6, 'y_min': 128, 'depth': 33}





if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out



M568 P{ state.currentTool } A1  ; Set target tool temp to standby temperature (to prevent overheating while brushing)

; Go to the start of the brush
G0 X-22.0 Y128 F50000

;M98 P"/sys/usr/lib/manhattan_move.g" X-22.0 Y128 Z0 F50000

; Side-to-side motions

G1 X-25 Y121.4 F50000
G1 X-19 Y128.0 F50000

G1 X-25 Y128.0 F50000
G1 X-19 Y134.6 F50000

G1 X-25 Y134.6 F50000
G1 X-19 Y141.2 F50000

G1 X-25 Y141.2 F50000
G1 X-19 Y147.8 F50000

G1 X-25 Y147.8 F50000
G1 X-19 Y154.4 F50000


; Front-to-back motions

G1 X-27.0 Y123 F50000
G1 X-22.0 Y166 F50000

G1 X-25.0 Y123 F50000
G1 X-20.0 Y166 F50000

G1 X-23.0 Y123 F50000
G1 X-18.0 Y166 F50000

; Front-to-back end

; One last time to clear any debree off
G0 X-22.0 Y128 F50000
G0 X-22.0 Y191 F50000


M568 P{ state.currentTool } A2  ; Restore the active temp

