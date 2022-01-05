; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 14.5, 'Y': 44.24, 'Z': -22.5})
G10 P0 X14.5000 Y44.2400 Z-22.5000
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.48, 'Y': 43.93, 'Z': -22.5})
G10 P1 X20.4800 Y43.9300 Z-22.5000
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -8.2, 'Y': 39.5, 'Z': -14})
G10 P2 X-8.2000 Y39.5000 Z-14
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -8.16, 'Y': 39.58, 'Z': -22.5})
G10 P3 X-8.1600 Y39.5800 Z-22.5000
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
