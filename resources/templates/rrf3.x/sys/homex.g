; homex.g
; called to home the x axis

{% import '__macros__/move.jinja' as move %}


if !move.axes[{{ axis.Y.index }}].homed
    abort "Please home Y first"
else
    ; Avoid accidentally clashing with the tools/Z column
    {{ move.avoid_tc_clash(indent=4)}}
    G1 H1 Y-400 F3000           ; move to the front 400mm (Y axis), stopping at the endstop
    G1 H1 Y2 F2000              ; move away from end

if state.currentTool >= 0
    abort "Refusing to home X with tool attached."

{% call move.rel_move() %}
{% call move.drop_motor_current(0.2) %}

G1 H2 Z3 F5000					; lift Z 3mm
G1 H1 X-400 F3000 				; move left 400mm, stopping at the endstop
G1 H1 X2 F2000 					; move away from end
G1 H2 Z-3 F1200					; lower Z

{% endcall %}
{% endcall %}
