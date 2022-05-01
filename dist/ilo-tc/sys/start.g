


;---- Home if ANY axis is not homed

var do_home = false
var axis_idx = 0

while var.axis_idx < #move.axes
    if !move.axes[var.axis_idx].homed
        set var.do_home = true
        break
    set var.axis_idx = var.axis_idx + 1

if var.do_home
    echo "Some axes not homed. Homing."
    G28


; ---- reset_global_prime_vars
set global.prime_first_tool_use = 1 ; see /sys/usr/prime.g
set global.prime_extrude_delay = 2 ; see /sys/usr/prime.g

; ---- reset_global_babystep_vars
set global.t0_babystep = 0.0
set global.t1_babystep = 0.0
set global.t2_babystep = 0.0
set global.t3_babystep = 0.0



M290 R0 S0  ; clear babystepping
