; tpre1.g
; called before tool 1 is selected




; Just in case - take care not to clash with the environment
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G53 G1 X82 Y180 F50000

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X82.0000 Y180.0000
G53 G1 F9444.4444 X82.0000 Y185.2111
G53 G1 F8888.8889 X82.0000 Y190.4222
G53 G1 F8333.3333 X82.0000 Y195.6333
G53 G1 F7777.7778 X82.0000 Y200.8444
G53 G1 F7222.2222 X82.0000 Y206.0556
G53 G1 F6666.6667 X82.0000 Y211.2667
G53 G1 F6111.1111 X82.0000 Y216.4778
G53 G1 F5555.5556 X82.0000 Y221.6889
G53 G1 F5000.0000 X82.0000 Y226.9000


;Collect
G53 G1 X82 Y226.9 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T1

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!
G91
G1 Z27.0 F1000
G90

G1 A13.5 B13.5  ; Adjust brush heights

M913 X100 Y100 ; Restore the motor current

;Move Out
G53 G1 X82 Y135.41 F4000
