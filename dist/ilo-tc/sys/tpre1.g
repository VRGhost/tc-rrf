; tpre1.g
; called before tool 1 is selected




; Just in case - take care not to clash with the environment
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


M98 P"/sys/usr/reset_tool_offsets.g"
;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G1 X82 Y180.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 1)"

G1 X82 Y210.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 1)"


M913 X60 Y60 ; Set the motor current to 60%

;Collect
G1 X82 Y226.9 F2500
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 1)"



;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z28 F1000
G90

M913 X100 Y100 ; Restore the motor current


; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3500, 'Y': 3500}}
M566 P1 X300 Y300

M201 P1 X3500 Y3500



;Move Out
G1 X82 Y130.0 F4000
