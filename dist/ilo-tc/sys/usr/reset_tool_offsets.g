; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.36, 'Y': 44.04, 'Z': -22.5})
G10 P0 X20.3600 Y44.0400 Z-22.5000
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 17.5, 'Y': 44.39, 'Z': -22.5})
G10 P1 X17.5000 Y44.3900 Z-22.5000
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -8.18, 'Y': 39.44, 'Z': -14})
G10 P2 X-8.1800 Y39.4400 Z-14
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': 20.34, 'Y': 43.68, 'Z': -22.5})
G10 P3 X20.3400 Y43.6800 Z-22.5000
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
