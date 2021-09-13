; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.77, 'Y': 44.22, 'Z': -4.86})
G10 P0 X20.7700 Y44.2200 Z-4.8600
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.48, 'Y': 43.73, 'Z': -5})
G10 P1 X20.4800 Y43.7300 Z-5
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -8, 'Y': 39.2, 'Z': -4.6})
G10 P2 X-8 Y39.2000 Z-4.6000
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -7.96, 'Y': 39.46, 'Z': -4.35})
G10 P3 X-7.9600 Y39.4600 Z-4.3500
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
