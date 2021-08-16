; tfree0.g
; called when tool 0 is freed

;Drop the bed
G91
G1 Z4 F1000
G90

;Purge nozzle
;M98 P"purge.g"

;Move In
G53 G1 X-7.4 Y130.0 F50000
G53 G1 X-7.4 Y180.0 F50000
G53 G1 X-7.4 Y200.0 F50000
G53 G1 X-7.4 Y226.3 F5000

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P2 S0

;Move Out
G53 G1 X-7.4 Y155.0 F50000