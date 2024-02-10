; tfree1.g
; called when tool 1 is freed





; Save tool position & settings
var orig_z_pos = move.axes[2].userPosition

; ---- save_tool_babystep(1)
set global.t1_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



; Just in case - take care not to clash with the environment
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

;Move to location
M400
G53 G1 X82 F50000
M400
G53 G1 Y175 F50000
M400




; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6

; Approach at reducing speed
G53 G1 F10000.0000 X82.0000 Y175.0000
G53 G1 F9444.4444 X82.0000 Y180.7111
G53 G1 F8888.8889 X82.0000 Y186.4222
G53 G1 F8333.3333 X82.0000 Y192.1333
G53 G1 F7777.7778 X82.0000 Y197.8444
G53 G1 F7222.2222 X82.0000 Y203.5556
G53 G1 F6666.6667 X82.0000 Y209.2667
G53 G1 F6111.1111 X82.0000 Y214.9778
G53 G1 F5555.5556 X82.0000 Y220.6889
G53 G1 F5000.0000 X82.0000 Y226.4000


M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Open Coupler
M98 P"/macros/Coupler - Unlock"

; M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P4 S0

;Move Out
G1 F2000

;; Jiggle on the way out - to release the lock
G53 G1 X81 Y225.9
G53 G1 X83 Y225.4
G53 G1 X82 Y223.4
G53 G1 Y225.4

G1 F50000
G53 G1 X82 Y175 Z{ var.orig_z_pos }
