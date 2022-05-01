; homey.g
; called to home the Y axis
{% import '__macros__/move.jinja' as move %}

{% call move.rel_move() %}
{% call move.drop_motor_current(0.2) %}

G1 H2 Z3 F5000				; lift Z 3mm
M400
G1 H1 Y-400 F3000 			; move to the front 400mm, stopping at the endstop
M400
G1 H1 Y2 F2000 				; move away from end
M400
G1 H2 Z-3 F1200				; lower Z

{% endcall %}
{% endcall %}
