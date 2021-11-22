; tpre2.g
; called before tool 2 is selected




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
G1 X218.2 Y200 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 2)"

G1 X218.2 Y230 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 2)"


M913 X60 Y60 ; Set the motor current to 60%

;Collect
G1 X218.2 Y242 F2500
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 2)"



;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z9.276 F1000
G90

M913 X100 Y100 ; Restore the motor current


; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3700, 'Y': 3700}}
M566 P2 X300 Y300

M201 P2 X3700 Y3700



;Move Out
G1 X218.2 Y150 F4000
