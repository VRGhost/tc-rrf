; tpost2.g
; called after tool 2 has been selected


M116 P2

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"
