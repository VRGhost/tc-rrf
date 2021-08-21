; tpre1.g
; called before tool 1 is selected



;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X83.78 Y180.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 1)"

G1 X83.78 Y210.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 1)"


M913 X30 Y30 ; Set the motor current to 30%

;Collect
G1 X83.78 Y232.62 F2500
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 1)"



;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z10.366 F1000
G90

M913 X100 Y100 ; Restore the motor current

; --- apply_speed_limits({'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 4000, 'Y': 4000}})
M566 X300 Y300
M201 X4000 Y4000
; --- apply_speed_limits() END


;Move Out
G1 X83.78 Y130.0 F4000
