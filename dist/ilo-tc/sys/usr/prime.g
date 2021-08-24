; This script is executed to prepare the nozzle for printing



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

var cur_nozzle_temp_8 = -273
var idx_9 = 0
while var.idx_9 < #heat.heaters
    if heat.heaters[var.idx_9].state = "active"
        set var.cur_nozzle_temp_8 = heat.heaters[var.idx_9].current
        break
    set var.idx_9 = var.idx_9 + 1

; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_8 - 5) > heat.coldExtrudeTemperature ? 1 : 0

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
