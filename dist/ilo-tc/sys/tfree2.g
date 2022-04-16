; tfree2.g
; called when tool 2 is freed






; ---- save_tool_babystep(2)
set global.t2_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



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
G53 G1 F10000.0000 X217.8000 Y140.9600
G53 G1 F9444.4444 X217.8000 Y152.2311
G53 G1 F8888.8889 X217.8000 Y163.5022
G53 G1 F8333.3333 X217.8000 Y174.7733
G53 G1 F7777.7778 X217.8000 Y186.0444
G53 G1 F7222.2222 X217.8000 Y197.3156
G53 G1 F6666.6667 X217.8000 Y208.5867
G53 G1 F6111.1111 X217.8000 Y219.8578
G53 G1 F5555.5556 X217.8000 Y231.1289
G53 G1 F5000.0000 X217.8000 Y242.4000



M913 X100 Y100 ; Restore the motor current

;Open Coupler
M98 P"/macros/Coupler - Unlock"

M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P6 S0

;Move Out
G53 G1 X217.8 Y180 F50000
