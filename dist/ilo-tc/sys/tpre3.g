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
G53 G1 X307.2 F50000
M400
G53 G1 Y175 F50000
M400



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X307.2000 Y175.0000
G53 G1 F9444.4444 X307.2000 Y180.6889
G53 G1 F8888.8889 X307.2000 Y186.3778
G53 G1 F8333.3333 X307.2000 Y192.0667
G53 G1 F7777.7778 X307.2000 Y197.7556
G53 G1 F7222.2222 X307.2000 Y203.4444
G53 G1 F6666.6667 X307.2000 Y209.1333
G53 G1 F6111.1111 X307.2000 Y214.8222
G53 G1 F5555.5556 X307.2000 Y220.5111
G53 G1 F5000.0000 X307.2000 Y226.2000


;Collect
G53 G1 X307.2 Y226.2 F2500


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
