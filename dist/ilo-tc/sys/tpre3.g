; tpre3.g
; called before tool 3 is selected





; Just in case - take care not to clash with the environment


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
G53 G1 X306.2 Y175 F50000



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X306.2000 Y175.0000
G53 G1 F9444.4444 X306.2000 Y180.7667
G53 G1 F8888.8889 X306.2000 Y186.5333
G53 G1 F8333.3333 X306.2000 Y192.3000
G53 G1 F7777.7778 X306.2000 Y198.0667
G53 G1 F7222.2222 X306.2000 Y203.8333
G53 G1 F6666.6667 X306.2000 Y209.6000
G53 G1 F6111.1111 X306.2000 Y215.3667
G53 G1 F5555.5556 X306.2000 Y221.1333
G53 G1 F5000.0000 X306.2000 Y226.9000


;Collect
G53 G1 X306.2 Y226.9 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T3

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 Z28.04 F1000
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END



G1 A14.02 B14.02  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
