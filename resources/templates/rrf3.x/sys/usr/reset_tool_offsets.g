; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

{% from '/__macros__/tools.jinja' import apply_tool_offsets -%}

; ---- T0
{{ apply_tool_offsets(tools.T0.offsets, 0) }}
; ---- T1
{{ apply_tool_offsets(tools.T1.offsets, 1) }}
; ---- T2
{{ apply_tool_offsets(tools.T2.offsets, 2) }}
; ---- T3
{{ apply_tool_offsets(tools.T3.offsets, 3) }}


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3