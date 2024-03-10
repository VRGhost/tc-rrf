; tpre3.g
; called before tool 3 is selected




var orig_z_pos = move.axes[2].userPosition

; lower the bed -- otherwise the z probe might run into the printed object,
;   as it extends down a bit below its actuation point (that is configured to be z=0 at the moment)


; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 H2 Z3 F5000                  ; Lower the bed
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END


; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
M400
G53 G1 X306.098 F50000
M400
G53 G1 Y175 F50000
M400



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X306.0980 Y175.0000
G53 G1 F9444.4444 X306.0980 Y180.5899
G53 G1 F8888.8889 X306.0980 Y186.1798
G53 G1 F8333.3333 X306.0980 Y191.7697
G53 G1 F7777.7778 X306.0980 Y197.3596
G53 G1 F7222.2222 X306.0980 Y202.9494
G53 G1 F6666.6667 X306.0980 Y208.5393
G53 G1 F6111.1111 X306.0980 Y214.1292
G53 G1 F5555.5556 X306.0980 Y219.7191
G53 G1 F5000.0000 X306.0980 Y225.3090


;Collect
G53 G1 X306.098 Y225.309 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T3


G1 A13.95 B13.95 Z{ var.orig_z_pos - -13.95 + 1 }  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
