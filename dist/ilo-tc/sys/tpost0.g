; tpost0.g
; called after tool 0 has been selected


M116 P0

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"
