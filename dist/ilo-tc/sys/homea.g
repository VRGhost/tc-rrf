; homeA.g
; called to home the A or B axis (brushes)


G91
M400                        ; Wait for any moves to finish
M913 A10                    ; MOTORS TO 60% CURRENT
G1 H2 A40 F50000
G92 A0                    ; Mark A as homed
G90
M913 A100                   ; MOTORS TO 100% CURRENT
