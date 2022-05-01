; homeall.g
; called to home all axes

M98 P"homea.g"
M400
M98 P"homeb.g"
M400
M98 P"homec.g"			; Home C (ToolHead)
M400
M98 P"homey.g"			; Home Y
M400
M98 P"homex.g"			; Home X
M400
M98 P"homez.g"			; Home Z
M400

G1 X150 Y-49 F15000		; Park
