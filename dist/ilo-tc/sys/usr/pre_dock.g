; This script is executed right before the nozzle is docked.



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

set var.can_extrude = 0 ; set to 'False' by default

var cur_nozzle_temp_45 = -273
; echo "Current tool: " ^ state.currentTool

; ------ get_nozzle_temp(var.cur_nozzle_temp_45, state.currentTool)
set var.cur_nozzle_temp_45 = -273


var cur_tool_heater_idx_48 = 0
var cur_heater_idx_47 = -1

if state.currentTool >= 0
    ; Valid tool ID
    while var.cur_tool_heater_idx_48 < #tools[state.currentTool].heaters
        set var.cur_heater_idx_47 = tools[state.currentTool].heaters[var.cur_tool_heater_idx_48]
        
        set var.cur_nozzle_temp_45 = max(var.cur_nozzle_temp_45, heat.heaters[var.cur_heater_idx_47].current)

        set var.cur_tool_heater_idx_48 = var.cur_tool_heater_idx_48 + 1


; ------ get_nozzle_temp() END


; echo "Tool temp: " ^ var.cur_nozzle_temp_45
; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_45 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    ; Too cold to extrude, skipping cleanup
    M99 ; return

M98 P"/macros/Go To Purge Spot"
M400
M98 P"/sys/usr/brush.g"
