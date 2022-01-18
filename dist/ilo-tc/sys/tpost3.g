; tpost3.g
; called after tool 3 has been selected


M116 P3

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"
