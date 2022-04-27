; homec.g
; called to home the C axis (coupler)





; ---- rel_move()
M400 ; wait for any pending moves to complete
G91


; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 C70 ; set the ['C'] current to 0.7


G1 H2 C-500 F5000
G92 C-45                    ; Mark C as homed


M400 ; wait for moves to complete
M913 C100 ; restore the ['C'] current

; ---- drop_motor_current() END

M400 ; wait for relative moves to complete
G90
; ---- rel_move() END


if state.currentTool >= 0
    ;Close Coupler (as there is a tool in it)
    M98 P"/macros/Coupler - Lock"
else
    ;Open Coupler
    M98 P"/macros/Coupler - Unlock"
