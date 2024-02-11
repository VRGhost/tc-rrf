; tfree2.g
; called when tool 2 is freed





; Save tool position & settings
var orig_z_pos = move.axes[2].userPosition

; ---- save_tool_babystep(2)
set global.t2_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



; Just in case - take care not to clash with the environment
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

;Move to location
M400
G53 G1 X217.7 F50000
M400
G53 G1 Y175 F50000
M400




; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6

; Approach at reducing speed
G53 G1 F10000.0000 X217.7000 Y175.0000
G53 G1 F9444.4444 X217.7000 Y182.4667
G53 G1 F8888.8889 X217.7000 Y189.9333
G53 G1 F8333.3333 X217.7000 Y197.4000
G53 G1 F7777.7778 X217.7000 Y204.8667
G53 G1 F7222.2222 X217.7000 Y212.3333
G53 G1 F6666.6667 X217.7000 Y219.8000
G53 G1 F6111.1111 X217.7000 Y227.2667
G53 G1 F5555.5556 X217.7000 Y234.7333
G53 G1 F5000.0000 X217.7000 Y242.2000


M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Open Coupler
M98 P"/macros/Coupler - Unlock"

; M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P6 S0

;Move Out
G1 F2000

;; Jiggle on the way out - to release the lock
G53 G1 X216.7 Y241.7
G53 G1 X218.7 Y241.2
G53 G1 X217.7 Y239.2
G53 G1 Y241.2

G1 F50000
G53 G1 X217.7 Y175 Z{ var.orig_z_pos }
