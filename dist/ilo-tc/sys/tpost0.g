; tpost0.g
; called after tool 0 has been selected



M116 P0

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"

; restore tool position
; ---- activate_tool_babystep(0)
M290 S{ global.t0_babystep } R0 ; R0 for "absolute mode"


M98 P"/sys/usr/lib/xyz_stack.g" S-1
