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
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 0)"

G53 G1 X-7.4 Y180.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 0)"

G53 G1 X-7.4 Y200.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 0)"


M913 X30 Y30 ; Set the motor current to 30%

G53 G1 X-7.4 Y226.3 F5000
if result != 0
    abort "[ERROR]: Unable to complete approach step #3 (tool 0)"


M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P2 S0

; Restore the global speed limits
; --- apply_speed_limits({'M566': {'X': 400, 'Y': 400, 'Z': 8, 'C': 2, 'E': [2, 2, 2, 2]}, 'M203': {'X': 35000, 'Y': 35000, 'Z': 1200, 'C': 5000, 'E': [5000, 5000, 5000, 5000]}, 'M201': {'X': 6000, 'Y': 6000, 'Z': 400, 'C': 500, 'E': [2500, 2500, 2500, 2500]}})
M566 C2 E2:2:2:2 X400 Y400 Z8
M203 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200
M201 C500 E2500:2500:2500:2500 X6000 Y6000 Z400
; --- apply_speed_limits() END


;Move Out
G53 G1 X-7.4 Y155.0 F50000
