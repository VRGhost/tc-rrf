; tpre0.g
; called before tool 0 is selected



M98 P"/sys/usr/reset_tool_offsets.g"
;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X-7.4 Y180.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 0)"

G1 X-7.4 Y210.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 0)"


M913 X60 Y60 ; Set the motor current to 60%

;Collect
G1 X-7.4 Y226.3 F2500
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 0)"



;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z10.44 F1000
G90

M913 X100 Y100 ; Restore the motor current


M566 C2 E2:2:2:2 P0 X400 Y400 Z8

M203 C5000 E5000:5000:5000:5000 P0 X35000 Y35000 Z1200

M201 C500 E2500:2500:2500:2500 P0 X6000 Y6000 Z400

M207 F5 P0 S10



;Move Out
G1 X-7.4 Y130.0 F4000
