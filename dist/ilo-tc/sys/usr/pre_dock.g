; This script is executed right before the nozzle is docked.



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

set var.can_extrude = 0 ; set to 'False' by default

var cur_nozzle_temp_17 = -273
echo "Current tool: " ^ state.currentTool

; ------ get_nozzle_temp(var.cur_nozzle_temp_17, state.currentTool)
set var.cur_nozzle_temp_17 = -273


var cur_tool_heater_idx_20 = 0
var cur_heater_idx_19 = -1

if state.currentTool >= 0
    ; Valid tool ID
    while var.cur_tool_heater_idx_20 < #tools[state.currentTool].heaters
        set var.cur_heater_idx_19 = tools[state.currentTool].heaters[var.cur_tool_heater_idx_20]
        
        set var.cur_nozzle_temp_17 = max(var.cur_nozzle_temp_17, heat.heaters[var.cur_heater_idx_19].current)

        set var.cur_tool_heater_idx_20 = var.cur_tool_heater_idx_20 + 1


; ------ get_nozzle_temp() END


echo "Tool temp: " ^ var.cur_nozzle_temp_17
; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_17 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    echo "Too cold to extrude, skipping cleanup"
    M99 ; return

M98 P"/macros/Go To Purge Spot"
G1 E-5 F400 ; retract 5mm of filament
M400
M98 P"/sys/usr/brush.g"
