; homeB.g
; called to home the A or B axis (brushes)




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91


; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 B100 ; set the ['B'] current to 1



G1 H1 B-50 F50000
G1 H1 B1                                           ; Back out a little bit
G92 B5                                ; Mark B as homed



M400 ; wait for moves to complete
M913 B100 ; restore the ['B'] current

; ---- drop_motor_current() END

M400 ; wait for relative moves to complete
G90
; ---- rel_move() END
