; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.77, 'Y': 44.22, 'Z': -4.769})
G10 P0 X20.7700 Y44.2200 Z-4.7690
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.48, 'Y': 43.73, 'Z': -4.729})
G10 P1 X20.4800 Y43.7300 Z-4.7290
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -8, 'Y': 39.2, 'Z': -4.422})
G10 P2 X-8 Y39.2000 Z-4.4220
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -7.96, 'Y': 39.46, 'Z': -4.25})
G10 P3 X-7.9600 Y39.4600 Z-4.2500
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
