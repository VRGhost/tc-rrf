{% from 'sys/usr/prime.g' import reset_global_prime_vars %}
{% from '__macros__/babystep.jinja' import reset_global_babystep_vars %}

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

M98 P"/sys/usr/lib/xyz_stack.g" S0


{{ reset_global_prime_vars() }}
{{ reset_global_babystep_vars() }}

M290 R0 S0  ; clear babystepping