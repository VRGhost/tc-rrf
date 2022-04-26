; tpost2.g
; called after tool 2 has been selected



M116 P2

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"

G1 Z{ global.toolchange_orig_z }; restore the tpre Z

; ---- activate_tool_babystep(2)
M290 S{ global.t2_babystep } R0 ; R0 for "absolute mode"

