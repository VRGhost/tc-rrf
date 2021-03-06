; tpre0.g
; called before tool 0 is selected





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
G53 G1 X-8 Y175 F50000



; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6



; Approach at reducing speed
G53 G1 F10000.0000 X-8.0000 Y175.0000
G53 G1 F9444.4444 X-8.0000 Y180.7000
G53 G1 F8888.8889 X-8.0000 Y186.4000
G53 G1 F8333.3333 X-8.0000 Y192.1000
G53 G1 F7777.7778 X-8.0000 Y197.8000
G53 G1 F7222.2222 X-8.0000 Y203.5000
G53 G1 F6666.6667 X-8.0000 Y209.2000
G53 G1 F6111.1111 X-8.0000 Y214.9000
G53 G1 F5555.5556 X-8.0000 Y220.6000
G53 G1 F5000.0000 X-8.0000 Y226.3000


;Collect
G53 G1 X-8 Y226.3 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T0

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 Z27.55 F1000
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END



G1 A13.775 B13.775  ; Adjust brush heights



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Move Out
G53 G1 Y175 F4000
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out
