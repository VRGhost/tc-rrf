; tpre3.g
; called before tool 3 is selected




; save the orig Z
set global.toolchange_orig_z = move.axes[2].userPosition

; Just in case - take care not to clash with the environment
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Unlock Coupler
M98 P"/macros/Coupler - Unlock"

;Move to location
G53 G1 X306.2 Y180 F50000

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X306.2000 Y180.0000
G53 G1 F9444.4444 X306.2000 Y185.2111
G53 G1 F8888.8889 X306.2000 Y190.4222
G53 G1 F8333.3333 X306.2000 Y195.6333
G53 G1 F7777.7778 X306.2000 Y200.8444
G53 G1 F7222.2222 X306.2000 Y206.0556
G53 G1 F6666.6667 X306.2000 Y211.2667
G53 G1 F6111.1111 X306.2000 Y216.4778
G53 G1 F5555.5556 X306.2000 Y221.6889
G53 G1 F5000.0000 X306.2000 Y226.9000


;Collect
G53 G1 X306.2 Y226.9 F2500


;Close Coupler
M98 P"/macros/Coupler - Lock"

M98 P"/sys/usr/configure_tool.g" T3

;WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!
;if you are using non-standard length hotends ensure the bed is lowered enough BEFORE undocking the tool!




; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 Z27.6 F1000
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END



G1 A13.8 B13.8  ; Adjust brush heights

M913 X100 Y100 ; Restore the motor current

;Move Out
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out
