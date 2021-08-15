; tpre0.g
; called before tool 0 is selected

;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X-7.4 Y180.0 F50000

;Move in
G1 X-7.4 Y210.0 F50000

;Collect
G1 X-7.4 Y226.3 F2500

;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z10.52 F1000
G90

;Move Out
G1 X-7.4 Y130.0 F4000

