; Set tool-specific overrides
; Parameters:
;   T[tool_id : int] - target tool (<0 for "no tool")

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

{% import '__macros__/tools.jinja' as tools_mod %}

{% macro apply_global_settings() -%}
; ----- apply_global_settings()
{% if extra_settings -%}
{% for (cmd, params) in extra_settings.items() -%}

{{ cmd }} {{ py.format_gcode_param_str(params) }}

{% endfor -%}
{% endif -%}
; ----- apply_global_settings() END
{% endmacro -%}

{%- macro configure_tool(py_tool_conf) -%}
    {{ apply_global_settings() }}

    {% if 'extra_settings' in py_tool_conf %}
; {{ py_tool_conf.extra_settings }}
        {%- for (cmd, params) in py_tool_conf.extra_settings.items() %}
{{ cmd }} {{ py.format_gcode_param_str(params, P=py_tool_conf.id) }}
        {%- endfor -%}
    {% endif %}

G10 {{ py.format_gcode_param_str(py_tool_conf.offsets, P=py_tool_conf.id) }}

    {% call(drive_id) tools_mod.foreach_extruder(py_tool_conf.id) -%}
        {% if py_tool_conf.extruder_settings -%}
            {% for (cmd, params) in py_tool_conf.extruder_settings.items() -%}

{{ cmd }} D{ {{ drive_id }} } {{ py.format_gcode_param_str(params) }} ; pressure advance

            {%- endfor %}
        {%- endif %}
    {%- endcall %}

{% endmacro -%}

if (param.T < 0)
    ; No tool configured
    {{ apply_global_settings() | indent(width=4) }}

{% for py_tool in tools.values() -%}
if (param.T == {{py_tool.id}})
    ; ---- T{{ py_tool.id }}
    {% filter indent(width=4) -%}
    {{ configure_tool(py_tool) }}
    {%- endfilter %}
{%- endfor %}