; tfree1.g
; called when tool 1 is freed

;Drop the bed
G91
G1 Z4 F1000
G90

;Purge nozzle
;M98 P"purge.g"

;Move In
G53 G1 X82.78 Y130.0 F50000
G53 G1 X82.78 Y180.0 F50000
G53 G1 X82.78 Y200.0 F50000

M913 X30 Y30 ; Set the motor current to 30%

G53 G1 X82.78 Y226.62 F5000

M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P4 S0

;Move Out
G53 G1 X82.78 Y155.0 F50000
