; tfree3.g
; called when tool 3 is freed




;Drop the bed
G91
G1 Z4 F1000
G90

; Just in case - take care not to clash with the environment
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

;Move In
G53 G1 X308.6 Y150.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 3)"

G53 G1 X308.6 Y200.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 3)"

G53 G1 X308.6 Y220.0 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 3)"


M913 X60 Y60 ; Set the motor current to 60%

G53 G1 X308.6 Y241.5 F5000
if result != 0
    abort "[ERROR]: Unable to complete approach step #3 (tool 3)"


M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

;fan off
M106 P8 S0

; Restore global extra settings

; ----- apply_global_settings()
; This macro applies all global settings that can be overriden in some other scripts
M566 A2 B2 C2 E2:2:2:2 X400 Y400 Z8

M203 A5000 B5000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

M201 A500 B500 C500 E2500:2500:2500:2500 X6000 Y6000 Z400

M207 F2400 R-0.3000 S10

; ----- apply_global_settings() END


;Move Out
G53 G1 X308.6 Y175.0 F50000
M98 P"/sys/usr/reset_tool_offsets.g"
