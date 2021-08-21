; tpre2.g
; called before tool 2 is selected



;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X214.5 Y200 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 2)"

G1 X214.5 Y230 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 2)"


M913 X60 Y60 ; Set the motor current to 60%

;Collect
G1 X214.5 Y243 F2500
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 2)"



;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z10 F1000
G90

M913 X100 Y100 ; Restore the motor current



;Move Out
G1 X214.5 Y150 F4000
