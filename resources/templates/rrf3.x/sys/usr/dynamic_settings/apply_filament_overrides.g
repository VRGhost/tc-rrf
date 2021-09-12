; Set fillament- and nozzle-specific overrides
; Parameters:
;   T[tool_id : int] - target tool
;   F[filament_name : string] - used filament
;   N[nozzle_diameter : float] - nozzle diameter
;
; Known filament names are: "PET", "PLA"

{% import '__macros__/util.jinja' as util %}

echo "Applying filament overrides for the Tool " ^ param.T ^ " with nozzle D=" ^ param.N ^ " and filament '" ^ param.F ^ "'"

var extrude_factor = 100 ; Default factor

{% for (filament_name, filament_settings) in filament_overrides.items() %}
{% set nozzle_diameters = filament_settings.keys() | sort | list %}
if param.F == "{{ filament_name }}"
    {% for (prev_d, cur_d, next_d) in py.zip([None] + nozzle_diameters, nozzle_diameters, nozzle_diameters[1:] + [None]) %}
    if {{ py.floatWithinBoundsCond('param.N', prev_d, cur_d, next_d) }}
        ; Nozzle diameter {{ cur_d }}
        set var.extrude_factor = {{ "%d"|format(filament_settings[cur_d]['extrude_factor'] * 100 | round) }} ; Real factor = {{ filament_settings[cur_d]['extrude_factor'] }}
    {% endfor %}
{% endfor %}

echo "Using extrude factor " ^ var.extrude_factor

{% call(drive_id) util.foreach('tools[{{ param.T }}].extruders') %}
M221 S{var.extrude_factor} D{ {{ drive_id }} }
{% endcall %}
