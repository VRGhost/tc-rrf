; homeA.g
; called to home the A or B axis (brushes)


G91
M400                        ; Wait for any moves to finish
M913 A30                    ; MOTORS TO 30% CURRENT
G1 H2 A-40 F50000
G1 H2 A1                            ; Back out a little bit
G92 A-11                    ; Mark A as homed
G90
M913 A100                   ; MOTORS TO 100% CURRENT
