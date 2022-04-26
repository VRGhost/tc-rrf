; tpost1.g
; called after tool 1 has been selected



M116 P1

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"

G1 Z{ global.toolchange_orig_z }; restore the tpre Z

; ---- activate_tool_babystep(1)
M290 S{ global.t1_babystep } R0 ; R0 for "absolute mode"

