; tfree0.g
; called when tool 0 is freed







; ---- save_tool_babystep(0)
set global.t0_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



; Just in case - take care not to clash with the environment
if move.axes[2].homed && move.axes[2].userPosition < 10 ; if Z < 10
    G1 Z10 ; slowly lower the bed
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
    G1 Y200 F2500 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

M913 X60 Y60 ; Set the motor current to 60%

; Approach at reducing speed
G53 G1 F10000.0000 X-8.0000 Y135.9600
G53 G1 F9444.4444 X-8.0000 Y145.9978
G53 G1 F8888.8889 X-8.0000 Y156.0356
G53 G1 F8333.3333 X-8.0000 Y166.0733
G53 G1 F7777.7778 X-8.0000 Y176.1111
G53 G1 F7222.2222 X-8.0000 Y186.1489
G53 G1 F6666.6667 X-8.0000 Y196.1867
G53 G1 F6111.1111 X-8.0000 Y206.2244
G53 G1 F5555.5556 X-8.0000 Y216.2622
G53 G1 F5000.0000 X-8.0000 Y226.3000



M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P2 S0

;Move Out
G53 G1 X-8 Y180 F50000



; ---- rel_move()
G91
G1 Z-13.775 F1000
G90
; ---- rel_move() END
