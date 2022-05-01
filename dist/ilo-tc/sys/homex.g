; homex.g
; called to home the x axis




if !move.axes[1].homed
    echo "Please home Y first"
    M99
else
    ; Avoid accidentally clashing with the tools/Z column
    ; ----- AVOID clashing with the TC walls
    if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
        G53 G0 Y140 F99999 ; slowly back out

    G1 H1 Y-400 F3000           ; move to the front 400mm (Y axis), stopping at the endstop
    G1 H1 Y2 F2000              ; move away from end

if state.currentTool >= 0
    echo "Refusing to home X with tool attached."
    M99



; ---- rel_move()
M400 ; wait for any pending moves to complete
G91


; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X20 Y20 ; set the ('X', 'Y') current to 0.2



G1 H2 Z3 F5000					; lift Z 3mm
G1 H1 X-400 F3000 				; move left 400mm, stopping at the endstop
G1 H1 X2 F2000 					; move away from end
G1 H2 Z-3 F1200					; lower Z



M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END

M400 ; wait for relative moves to complete
G90
; ---- rel_move() END
