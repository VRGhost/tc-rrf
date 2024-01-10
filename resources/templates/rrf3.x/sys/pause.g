{% import '__macros__/move.jinja' as move %}

{% call move.rel_move() %}
G1 H2 Z5 F5000			; lift Z 5mm
{% endcall %}

G1 X-5 Y200 F50000		; move out the way.
