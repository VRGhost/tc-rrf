; tfree3.g
; called when tool 3 is freed



;Drop the bed
G91
G1 Z4 F1000
G90

;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

;Move In
G53 G1 X304.5 Y150 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #0 (tool 3)"

G53 G1 X304.5 Y200 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #1 (tool 3)"

G53 G1 X304.5 Y220 F50000
if result != 0
    abort "[ERROR]: Unable to complete approach step #2 (tool 3)"


M913 X60 Y60 ; Set the motor current to 60%

G53 G1 X304.5 Y243 F5000
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
M566 C2 E2:2:2:2 X400 Y400 Z8

M203 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

M201 C500 E2500:2500:2500:2500 X6000 Y6000 Z400

M207 F5 S10

; ----- apply_global_settings() END


;Move Out
G53 G1 X304.5 Y175 F50000
M98 P"/sys/usr/reset_tool_offsets.g"
