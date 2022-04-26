; homec.g
; called to home the C axis (coupler)





; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
M913 C70					; XY MOTORS TO 60% CURRENT
G1 H2 C-500 F5000
G92 C-45                    ; Mark C as homed
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END

M913 C100					; XY MOTORS TO 100% CURRENT

if state.currentTool >= 0
    ;Close Coupler (as there is a tool in it)
    M98 P"/macros/Coupler - Lock"
else
    ;Open Coupler
    M98 P"/macros/Coupler - Unlock"
