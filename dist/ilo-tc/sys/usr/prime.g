; This script is executed to prepare the nozzle for printing



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

var cur_nozzle_idx_9 = (state.currentTool >= 0) ? tools[state.currentTool].filamentExtruder : -1
var cur_nozzle_temp_10 = (cur_nozzle_idx >= 0) ? heat.heaters[var.cur_nozzle_idx_9].current : -273

echo "T=" ^ var.cur_nozzle_temp_10 ^ "H=" ^ heat.coldExtrudeTemperature
; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_10 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    echo "Too cold to extrude, skipping priming"
    M99 ; return

M98 P"/macros/Go To Purge Spot"

G1 E20 F400 ; extrude 30mm of filament
M400
M98 P"/sys/usr/brush.g"
M400

M98 P"/macros/Go To Purge Spot"
