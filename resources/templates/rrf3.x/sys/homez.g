; homez.g
; called to home the Z axis

if !move.axes[0].homed || !move.axes[1].homed
    M98 P"homey.g"          ; Home Y
    M98 P"homex.g"          ; Home X

M98 P"/macros/Coupler - Unlock"	; Open Coupler

G91 							; Relative mode
G1 H2 Z5 F5000					; Lower the bed
G90								; back to absolute positioning

G1 X150 Y100 F50000				; Position the endstop above the bed centre

M558 F1000
G30
M558 F300
G30

