; tfree2.g
; called when tool 2 is freed





; Save tool position & settings

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
G53 G1 X217.4 F50000
M400
G53 G1 Y175 F50000
M400




; ---- drop_motor_current()
M400 ; wait for any pending moves to complete
M913 X60 Y60 ; set the ('X', 'Y') current to 0.6

; Approach at reducing speed
G53 G1 F10000.0000 X217.4000 Y175.0000
G53 G1 F9444.4444 X217.4000 Y182.4444
G53 G1 F8888.8889 X217.4000 Y189.8889
G53 G1 F8333.3333 X217.4000 Y197.3333
G53 G1 F7777.7778 X217.4000 Y204.7778
G53 G1 F7222.2222 X217.4000 Y212.2222
G53 G1 F6666.6667 X217.4000 Y219.6667
G53 G1 F6111.1111 X217.4000 Y227.1111
G53 G1 F5555.5556 X217.4000 Y234.5556
G53 G1 F5000.0000 X217.4000 Y242.0000


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


;; BOWDEN extruder - bit tempermental to disconnect
;; Jiggle on the way out - to release the lock
G53 G1 X216.4 Y241.5
G53 G1 X218.4 Y241.0
G53 G1 X217.4 Y239.0
G53 G1 Y241.0


G1 F50000
G53 G1 X217.4 Y175
