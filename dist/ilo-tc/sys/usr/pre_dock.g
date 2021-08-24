; This script is executed right before the nozzle is docked.



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

var cur_nozzle_idx_6 = (state.currentTool >= 0) ? tools[state.currentTool].filamentExtruder : -1
var cur_nozzle_temp_7 = (cur_nozzle_idx >= 0) ? heat.heaters[var.cur_nozzle_idx_6].current : -273

echo "T=" ^ var.cur_nozzle_temp_7 ^ "H=" ^ heat.coldExtrudeTemperature
; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_7 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    echo "Too cold to extrude, skipping cleanup"
    M99 ; return

M98 P"/macros/Go To Purge Spot"
G1 E-5 F400 ; retract 5mm of filament
M400
M98 P"/sys/usr/brush.g"
