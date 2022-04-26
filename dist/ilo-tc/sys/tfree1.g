; tfree1.g
; called when tool 1 is freed






; ---- save_tool_babystep(1)
set global.t1_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



; Just in case - take care not to clash with the environment
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X82.0000 Y135.4100
G53 G1 F9444.4444 X82.0000 Y145.5756
G53 G1 F8888.8889 X82.0000 Y155.7411
G53 G1 F8333.3333 X82.0000 Y165.9067
G53 G1 F7777.7778 X82.0000 Y176.0722
G53 G1 F7222.2222 X82.0000 Y186.2378
G53 G1 F6666.6667 X82.0000 Y196.4033
G53 G1 F6111.1111 X82.0000 Y206.5689
G53 G1 F5555.5556 X82.0000 Y216.7344
G53 G1 F5000.0000 X82.0000 Y226.9000



M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

; M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P4 S0

;Move Out
G53 G1 X82 Y180 F50000



; ---- rel_move()
M400 ; wait for any pending moves to complete
G91
G1 Z-13.6 F1000
M400 ; wait for relative moves to complete
G90
; ---- rel_move() END
