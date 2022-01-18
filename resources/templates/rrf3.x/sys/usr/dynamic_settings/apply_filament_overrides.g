; Set fillament- and nozzle-specific overrides
; Parameters:
;   T[tool_id : int] - target tool
;   F[filament_name : string] - used filament
;   N[nozzle_diameter : float] - nozzle diameter
;
; Known filament names are: "PET", "PLA"

{% import '__macros__/tools.jinja' as tools_mod %}

{% macro extruder_m221(tool_id, m221_kwargs) -%}
; extruder_m221({{tool_id}}, {{m221_kwargs}}) ( Set extrude factor override percentage )
{% call(drive_id) tools_mod.foreach_extruder(tool_id) -%}

M221 D{ {{drive_id}} } {{ py.format_gcode_param_str(m221_kwargs) }}

{%- endcall %}
; extruder_m221() END
{%- endmacro %}



{%- macro apply_tool_mode(tool, nozzle_d, filament) -%}
; apply_tool_mode(tool={{tool.id}}, nozzle_d={{nozzle_d}}, filament={{filament}})
{%- set filament_settings = py.get_merged_dynamic_overrides(tool_id=tool.id, nozzle_d=nozzle_d, filament=filament) %}
{{ extruder_m221(tool.id, filament_settings['M221']) }}
M207 P{{tool.id}} {{ py.format_gcode_param_str(filament_settings.get('M207', {})) }}
; apply_tool_mode() END
{% endmacro -%}

echo "Applying filament overrides for the Tool " ^ param.T ^ " with nozzle D=" ^ param.N ^ " and filament '" ^ param.F ^ "'"

{% for py_tool in tools.values() -%}
{% for (filament_name, filament_settings) in dynamic_overrides.filaments.items() -%}
{% set nozzle_diameters = filament_settings.nozzles.keys() | sort | list -%}
{% for (prev_d, cur_d, next_d) in py.zip([None] + nozzle_diameters, nozzle_diameters, nozzle_diameters[1:] + [None]) -%}

if (param.T == {{py_tool.id}}) && (param.F == "{{ filament_name }}") && {{ py.floatWithinBoundsCond('param.N', prev_d, cur_d, next_d) }}
    {% filter indent(width=4) -%}
    {{ apply_tool_mode(tool=py_tool, nozzle_d=cur_d, filament=filament_name) }}
    {%- endfilter %}

{% endfor %}
{%- endfor %}
{%- endfor %}

