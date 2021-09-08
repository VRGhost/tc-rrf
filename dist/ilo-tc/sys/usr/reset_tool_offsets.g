; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 19.75, 'Y': 45.12, 'Z': -6.34})
G10 P0 X19.7500 Y45.1200 Z-6.3400
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 19.78, 'Y': 43.41, 'Z': -6.02})
G10 P1 X19.7800 Y43.4100 Z-6.0200
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -11.6, 'Y': 37.9, 'Z': -7.384})
G10 P2 X-11.6000 Y37.9000 Z-7.3840
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -10.96, 'Y': 37.76, 'Z': -4.064})
G10 P3 X-10.9600 Y37.7600 Z-4.0640
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
