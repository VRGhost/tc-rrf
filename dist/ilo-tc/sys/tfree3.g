; tfree3.g
; called when tool 3 is freed





; Save tool position & settings
var orig_z_pos = move.axes[2].userPosition

; ---- save_tool_babystep(3)
set global.t3_babystep = move.axes[2].babystep ; only Z babystepping is supported for now



; Just in case - take care not to clash with the environment
; ----- AVOID clashing with the TC walls
if move.axes[1].homed && move.axes[1].machinePosition > 140 ; if Y > ~184 (user position, somewhere in the TC docking area)
    G53 G0 Y140 F99999 ; slowly back out


;Purge nozzle
M98 P"/sys/usr/pre_dock.g"

;Move to location
M400
G53 G1 X306.098 F50000
M400
G53 G1 Y175 F50000
M400




; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6

; Approach at reducing speed
G53 G1 F10000.0000 X306.0980 Y175.0000
G53 G1 F9444.4444 X306.0980 Y180.6887
G53 G1 F8888.8889 X306.0980 Y186.3773
G53 G1 F8333.3333 X306.0980 Y192.0660
G53 G1 F7777.7778 X306.0980 Y197.7547
G53 G1 F7222.2222 X306.0980 Y203.4433
G53 G1 F6666.6667 X306.0980 Y209.1320
G53 G1 F6111.1111 X306.0980 Y214.8207
G53 G1 F5555.5556 X306.0980 Y220.5093
G53 G1 F5000.0000 X306.0980 Y226.1980


M400 ; wait for moves to complete
M913 X100 Y100 ; restore the ('X', 'Y') current

; ---- drop_motor_current() END


;Open Coupler
M98 P"/macros/Coupler - Unlock"

; M98 P"/sys/usr/configure_tool.g" T-1

;fan off
M106 P8 S0

;Move Out
G1 F2000

;; Jiggle on the way out - to release the lock
G53 G1 X305.098 Y225.698
G53 G1 X307.098 Y225.198
G53 G1 X306.098 Y223.198
G53 G1 Y225.198

G1 F50000
G53 G1 X306.098 Y175 Z{ var.orig_z_pos }
