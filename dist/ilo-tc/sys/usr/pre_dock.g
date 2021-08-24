; This script is executed right before the nozzle is docked.



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

var cur_nozzle_temp_6 = -273
var idx_7 = 0
while var.idx_7 < #heat.heaters
    if heat.heaters[var.idx_7].state = "active"
        set var.cur_nozzle_temp_6 = heat.heaters[var.idx_7].current
        break
    set var.idx_7 = var.idx_7 + 1

; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_6 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    echo "Too cold to extrude, skipping cleanup"
    M99 ; return

M98 P"/macros/Go To Purge Spot"
G1 E-5 F400 ; retract 5mm of filament
M400
M98 P"/sys/usr/brush.g"
