; homeB.g
; called to home the A or B axis (brushes)




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91

M913 B30                                           ; MOTORS TO 30% CURRENT
G1 H2 B-40 F50000
G1 H2 B1                                           ; Back out a little bit
G92 B3.8                                ; Mark B as homed

M400 ; wait for relative moves to complete
G90
; ---- rel_move() END


M913 B100                   ; MOTORS TO 100% CURRENT
