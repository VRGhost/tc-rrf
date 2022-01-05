; tfree1.g
; called when tool 1 is freed




;Drop the bed
;G91
;G1 Z4 F1000
;G90

; Just in case - take care not to clash with the environment
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X82.0000 Y135.6100
G53 G1 F9444.4444 X82.0000 Y145.7533
G53 G1 F8888.8889 X82.0000 Y155.8967
G53 G1 F8333.3333 X82.0000 Y166.0400
G53 G1 F7777.7778 X82.0000 Y176.1833
G53 G1 F7222.2222 X82.0000 Y186.3267
G53 G1 F6666.6667 X82.0000 Y196.4700
G53 G1 F6111.1111 X82.0000 Y206.6133
G53 G1 F5555.5556 X82.0000 Y216.7567
G53 G1 F5000.0000 X82.0000 Y226.9000



M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P4 S0

; Restore global extra settings

; ----- apply_global_settings()
; This macro applies all global settings that can be overriden in some other scripts
M566 A2 B2 C2 E2:2:2:2 X400 Y400 Z8

M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

M201 A500 B500 C500 E2500:2500:2500:2500 X6000 Y6000 Z400

M207 F2400 S10

; ----- apply_global_settings() END


;Move Out
G53 G1 X82 Y180 F50000
M98 P"/sys/usr/reset_tool_offsets.g"
