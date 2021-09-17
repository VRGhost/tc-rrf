; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.77, 'Y': 44.22, 'Z': -5.148})
G10 P0 X20.7700 Y44.2200 Z-5.1480
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.48, 'Y': 43.93, 'Z': -5.188})
G10 P1 X20.4800 Y43.9300 Z-5.1880
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -8.2, 'Y': 39.5, 'Z': -4.7})
G10 P2 X-8.2000 Y39.5000 Z-4.7000
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -8.16, 'Y': 39.58, 'Z': -4.55})
G10 P3 X-8.1600 Y39.5800 Z-4.5500
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
