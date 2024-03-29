; tpre1.g
; called before tool 1 is selected




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
G53 G1 X82 F50000
M400
G53 G1 Y175 F50000
M400



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X82.0000 Y175.0000
G53 G1 F9444.4444 X82.0000 Y180.7111
G53 G1 F8888.8889 X82.0000 Y186.4222
G53 G1 F8333.3333 X82.0000 Y192.1333
G53 G1 F7777.7778 X82.0000 Y197.8444
G53 G1 F7222.2222 X82.0000 Y203.5556
G53 G1 F6666.6667 X82.0000 Y209.2667
G53 G1 F6111.1111 X82.0000 Y214.9778
G53 G1 F5555.5556 X82.0000 Y220.6889
G53 G1 F5000.0000 X82.0000 Y226.4000


;Collect
G53 G1 X82 Y226.4 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T1


G1 A13.84 B13.84 Z{ var.orig_z_pos - -13.84 + 1 }  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
