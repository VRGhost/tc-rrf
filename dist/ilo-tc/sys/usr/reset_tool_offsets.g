; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.45, 'Y': 44.42, 'Z': -5.22})
G10 P0 X20.4500 Y44.4200 Z-5.2200
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.38, 'Y': 44.01, 'Z': -5.06})
G10 P1 X20.3800 Y44.0100 Z-5.0600
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -9, 'Y': 39, 'Z': -5})
G10 P2 X-9 Y39 Z-5
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -9, 'Y': 39, 'Z': -5})
G10 P3 X-9 Y39 Z-5
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
