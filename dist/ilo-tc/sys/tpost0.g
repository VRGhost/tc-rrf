; tpost0.g
; called after tool 0 has been selected

;heatup
M116 P0

var toolZOffset = 0
if state.currentTool >= 0
    set var.toolZOffset = tools[state.currentTool].offsets[2]

G1 A{var.toolZOffset} B{var.toolZOffset}
;prime nozzle
M98 P"/sys/usr/prime.g"

M106 R1 ; restore print cooling fan speed
