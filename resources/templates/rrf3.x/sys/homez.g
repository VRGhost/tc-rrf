; homez.g
; called to home the Z axis

{% import '__macros__/move.jinja' as move %}

if !move.axes[0].homed || !move.axes[1].homed
    echo "Please home X and Y first"
    M99

if state.currentTool >= 0
    echo "Refusing to home Z with tool attached."
    M99

M98 P"/macros/Coupler - Unlock"	; Open Coupler (just in case)

{% call move.rel_move() %}
G1 H2 Z5 F5000					; Lower the bed
{% endcall %}

G1 X150 Y100 F50000				; Position the endstop above the bed centre

M558 F1000
G30
M558 F300
G30

