; homeB.g
; called to home the A or B axis (brushes)


G91
M400                        ; Wait for any moves to finish
M913 B30                    ; MOTORS TO 30% CURRENT
G1 H2 B 500 F5000
G92 B0                    ; Mark B as homed
G90
M913 C100                   ; MOTORS TO 100% CURRENT
