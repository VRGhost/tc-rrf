; Reset offsets for all tools

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6

; ---- T0
; --- apply_tool_offsets(0, {'X': 20.15, 'Y': 44.72, 'Z': -5.53})
G10 P0 X20.1500 Y44.7200 Z-5.5300
; --- apply_tool_offsets() END
; ---- T1
; --- apply_tool_offsets(1, {'X': 20.08, 'Y': 43.61, 'Z': -5.39})
G10 P1 X20.0800 Y43.6100 Z-5.3900
; --- apply_tool_offsets() END
; ---- T2
; --- apply_tool_offsets(2, {'X': -9.9, 'Y': 38.6, 'Z': -5.77})
G10 P2 X-9.9000 Y38.6000 Z-5.7700
; --- apply_tool_offsets() END
; ---- T3
; --- apply_tool_offsets(3, {'X': -9.66, 'Y': 38.56, 'Z': -5.77})
G10 P3 X-9.6600 Y38.5600 Z-5.7700
; --- apply_tool_offsets() END


;M572 D0 S0.2                       ; pressure advance T0
;M572 D1 S0.2                       ; pressure advance T1
;M572 D2 S0.2                       ; pressure advance T2
;M572 D3 S0.2                       ; pressure advance T3
