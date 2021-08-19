; tfree2.g
; called when tool 2 is freed

;Drop the bed
G91
G1 Z4 F1000
G90

;Purge nozzle
;M98 P"purge.g"

;Move In
G53 G1 X214.5 Y150 F50000
G53 G1 X214.5 Y200 F50000
G53 G1 X214.5 Y220 F50000

M913 X30 Y30 ; Set the motor current to 30%

G53 G1 X214.5 Y243 F5000

M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P6 S0

;Move Out
G53 G1 X214.5 Y175 F50000
