



; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 S2 Z5 F5000			; lift Z 5mm
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END


G1 X-5 Y200 F50000		; move out the way.
