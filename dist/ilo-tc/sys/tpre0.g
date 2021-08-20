; tpre0.g
; called before tool 0 is selected

;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X-7.4 Y180.0 F50000

;Move in
G1 X-7.4 Y210.0 F50000


M913 X30 Y30 ; Set the motor current to 30%

;Collect
G1 X-7.4 Y226.3 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z10.52 F1000
G90

M913 X100 Y100 ; Restore the motor current

; --- apply_speed_limits({'M566': {'X': 300, 'Y': 300}, 'M203': {'X': 30000, 'Y': 30000}, 'M201': {'X': 4500, 'Y': 4500}})
M566 X300 Y300
M203 X30000 Y30000
M201 X4500 Y4500
; --- apply_speed_limits() END


;Move Out
G1 X-7.4 Y130.0 F4000
