; homec.g
; called to home the C axis (coupler)

{% import '__macros__/move.jinja' as move %}

{% call move.rel_move() %}
{% call move.drop_motor_current(0.7, motors=['C']) %}
G1 H2 C-500 F5000
G92 C-45                    ; Mark C as homed
{% endcall %}
{% endcall %}

;Open Coupler
M98 P"/macros/Coupler - Unlock"
