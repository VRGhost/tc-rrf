    ; A piece of code to put & restore XYZ coords for the tool

{% import "__macros__/move.jinja" as move -%}

{% set stack_depth = 5 %}

{% macro declare_globals() %}
; XYZ stack globals

global xyz_stack_current_depth = -1

{% for idx in range(stack_depth) -%}
global xyz_stack_level_{{idx}}_x = 0
global xyz_stack_level_{{idx}}_y = 0
global xyz_stack_level_{{idx}}_z = 99999
{% endfor %}

{% endmacro %}

; Params:
;   S1 - push current values on the stack
;   S0 - erase the stack state
;   S-1 - pop and apply current values

M400

if param.S = 0
    set global.xyz_stack_current_depth = -1
{%- for idx in range(stack_depth) %}
    set global.xyz_stack_level_{{idx}}_x = 0
    set global.xyz_stack_level_{{idx}}_y = 0
    set global.xyz_stack_level_{{idx}}_z = 99999
{% endfor -%}
elif param.S = 1
    ; Save current pos on the stack
    if ( move.axes[{{ py.g.axis.X.index }}].userPosition < 0 ) || ( move.axes[{{ py.g.axis.Y.index }}].userPosition < 0 )
        ; X or Y are negative - do not save such coords on the stack
        echo "Negative XY, not saving"
        M99
    if ( move.axes[{{ py.g.axis.X.index }}].userPosition > {{ py.g.bed.width }} ) || ( move.axes[{{ py.g.axis.Y.index }}].userPosition > {{ py.g.bed.depth }} )
        ; X or Y are negative - do not save such coords on the stack
        echo "Outside of the bed, not saving"
        M99
{%- for idx in range(stack_depth) | reverse %}
    if global.xyz_stack_current_depth == {{ idx - 1 }}
        set global.xyz_stack_level_{{idx}}_x = move.axes[{{ py.g.axis.X.index }}].userPosition
        set global.xyz_stack_level_{{idx}}_y = move.axes[{{ py.g.axis.Y.index }}].userPosition
        set global.xyz_stack_level_{{idx}}_z = move.axes[{{ py.g.axis.Z.index }}].userPosition
        set global.xyz_stack_current_depth = {{ idx }}
{% endfor -%}
elif param.S = -1
    ; Restore position from the stack
    {{ move.avoid_tc_clash(indent=4) }}
{%- for idx in range(stack_depth) %}
    if global.xyz_stack_current_depth == {{ idx }}
        M400
        G0 X{ global.xyz_stack_level_{{idx}}_x } Y{ global.xyz_stack_level_{{idx}}_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_{{idx}}_z } F99999
        M400
        set global.xyz_stack_current_depth = {{ idx - 1 }}
{% endfor -%}
else
    echo "Unsupported param.S =" ^ param.S
    M99