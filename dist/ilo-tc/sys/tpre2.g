; tpre2.g
; called before tool 2 is selected




var orig_z_pos = move.axes[2].userPosition

; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
M400
G53 G1 X217.4 F50000
M400
G53 G1 Y175 F50000
M400



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X217.4000 Y175.0000
G53 G1 F9444.4444 X217.4000 Y182.4889
G53 G1 F8888.8889 X217.4000 Y189.9778
G53 G1 F8333.3333 X217.4000 Y197.4667
G53 G1 F7777.7778 X217.4000 Y204.9556
G53 G1 F7222.2222 X217.4000 Y212.4444
G53 G1 F6666.6667 X217.4000 Y219.9333
G53 G1 F6111.1111 X217.4000 Y227.4222
G53 G1 F5555.5556 X217.4000 Y234.9111
G53 G1 F5000.0000 X217.4000 Y242.4000


;Collect
G53 G1 X217.4 Y242.4 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T2


G1 A13.36 B13.36 Z{ var.orig_z_pos - -13.36 + 1 }  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
