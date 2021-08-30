; homeA.g
; called to home the A or B axis (brushes)


G91
M400                        ; Wait for any moves to finish
M913 A30                    ; MOTORS TO 30% CURRENT
G1 H2 A 500 F5000
G92 A0                    ; Mark A as homed
G90
M913 C100                   ; MOTORS TO 100% CURRENT
