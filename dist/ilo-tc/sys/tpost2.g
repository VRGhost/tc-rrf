; tpost2.g
; called after tool 2 has been selected



M116 P2

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"

; restore tool position
; ---- activate_tool_babystep(2)
M290 S{ global.t2_babystep } R0 ; R0 for "absolute mode"




; move to pre-tool change restore point
;G0 R2 X0 Y0 Z2 F99999
;G0 R2 X0 Y0 Z0 F2000
