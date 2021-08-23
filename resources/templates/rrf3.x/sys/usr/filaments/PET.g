; M409 K"sensors" F"d99vn"
; M98 P"/sys/usr/filamets/PETG.g"

{% from '/__macros__/tools.jinja' import amend_current_tool_offsets -%}

{{ amend_current_tool_offsets(dz=-0.1) }}