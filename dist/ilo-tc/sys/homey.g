; homey.g
; called to home the Y axis




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91


; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X20 Y20 ; set the ('X', 'Y') current to 0.2



G1 H2 Z3 F5000				; lift Z 3mm
M400
G1 H1 Y-400 F3000 			; move to the front 400mm, stopping at the endstop
M400
G1 H1 Y2 F2000 				; move away from end
M400
G1 H2 Z-3 F1200				; lower Z



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END

M400 ; wait for relative moves to complete
G90
; ---- rel_move() END
