; tpre3.g
; called before tool 3 is selected




var orig_z_pos = move.axes[2].userPosition

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
G53 G1 F9444.4444 X306.0980 Y180.6887
G53 G1 F8888.8889 X306.0980 Y186.3773
G53 G1 F8333.3333 X306.0980 Y192.0660
G53 G1 F7777.7778 X306.0980 Y197.7547
G53 G1 F7222.2222 X306.0980 Y203.4433
G53 G1 F6666.6667 X306.0980 Y209.1320
G53 G1 F6111.1111 X306.0980 Y214.8207
G53 G1 F5555.5556 X306.0980 Y220.5093
G53 G1 F5000.0000 X306.0980 Y226.1980


;Collect
G53 G1 X306.098 Y226.198 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T3


G1 A14.02 B14.02 Z{ var.orig_z_pos - -14.02 + 1 }  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
