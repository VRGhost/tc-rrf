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
G53 G1 X217.8 Y180 F50000

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X217.8000 Y180.0000
G53 G1 F9444.4444 X217.8000 Y186.9333
G53 G1 F8888.8889 X217.8000 Y193.8667
G53 G1 F8333.3333 X217.8000 Y200.8000
G53 G1 F7777.7778 X217.8000 Y207.7333
G53 G1 F7222.2222 X217.8000 Y214.6667
G53 G1 F6666.6667 X217.8000 Y221.6000
G53 G1 F6111.1111 X217.8000 Y228.5333
G53 G1 F5555.5556 X217.8000 Y235.4667
G53 G1 F5000.0000 X217.8000 Y242.4000


;Collect
G53 G1 X217.8 Y242.4 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z28 F1000
G90

G1 A14 B14  ; Adjust brush heights

M913 X100 Y100 ; Restore the motor current


; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3700, 'Y': 3700}}
M566 P2 X300 Y300

M201 P2 X3700 Y3700



;Move Out
G53 G1 X217.8 Y140.56 F4000
