; This script is executed to prepare the nozzle for printing

{% import '__macros__/heat.jinja' as heat %}

{% macro declare_global_prime_vars() -%}
; ---- declare_global_prime_vars
global prime_extrude_delay = 2 ; seconds
global prime_first_tool_use = 1 ; this int is used to mark what tool hadn't been initially primed
{% endmacro -%}

{% macro reset_global_prime_vars() -%}
; ---- reset_global_prime_vars
set global.prime_first_tool_use = 1 ; see /sys/usr/prime.g
set global.prime_extrude_delay = 2 ; see /sys/usr/prime.g
{% endmacro %}


var can_extrude = 0
{{ heat.is_hot_enough_to_extrude('var.can_extrude') }}

if var.can_extrude <= 0
    ; "Too cold to extrude, skipping priming"
    M99 ; return

{% macro check_and_mark_first_nozzle_use(tool_idx) -%}
; ---- check_and_mark_first_nozzle_use({{ tool_idx }})
{% set tool_prime_id = [2, 3, 5, 7][tool_idx] -%}
if state.currentTool == {{ tool_idx }} && mod(global.prime_first_tool_use, {{ tool_prime_id }}) != 0
    ; The tool ID is not present in the global state. This is the first use of the tool
    set global.prime_first_tool_use = global.prime_first_tool_use * {{ tool_prime_id }}
    set var.is_first_use = true
; ---- check_and_mark_first_nozzle_use() END
{% endmacro -%}

var is_first_use = false

{% for idx in range(4) %}
{{ check_and_mark_first_nozzle_use(idx) }}
{% endfor %}

M98 P"/macros/Go To Purge Spot"

G1 E{ var.is_first_use ? 90 : 40 } F400 ; extrude 30mm of filament
M400
G4 S{ global.prime_extrude_delay } ; wait
M98 P"/sys/usr/brush.g"
M400