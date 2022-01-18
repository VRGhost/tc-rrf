; This script is executed right before the nozzle is docked.



var can_extrude = 0


; ------ is_hot_enough_to_extrude(var.can_extrude)

set var.can_extrude = 0 ; set to 'False' by default

var cur_nozzle_temp_41 = -273
; echo "Current tool: " ^ state.currentTool

; ------ get_nozzle_temp(var.cur_nozzle_temp_41, state.currentTool)
set var.cur_nozzle_temp_41 = -273


var cur_tool_heater_idx_44 = 0
var cur_heater_idx_43 = -1

if state.currentTool >= 0
    ; Valid tool ID
    while var.cur_tool_heater_idx_44 < #tools[state.currentTool].heaters
        set var.cur_heater_idx_43 = tools[state.currentTool].heaters[var.cur_tool_heater_idx_44]
        
        set var.cur_nozzle_temp_41 = max(var.cur_nozzle_temp_41, heat.heaters[var.cur_heater_idx_43].current)

        set var.cur_tool_heater_idx_44 = var.cur_tool_heater_idx_44 + 1


; ------ get_nozzle_temp() END


; echo "Tool temp: " ^ var.cur_nozzle_temp_41
; Allow some cooldown (just in case)
set var.can_extrude = (var.cur_nozzle_temp_41 - 5) > heat.coldExtrudeTemperature ? 1 : 0

; ------ is_hot_enough_to_extrude() END



if var.can_extrude <= 0
    ; Too cold to extrude, skipping cleanup
    M99 ; return

M98 P"/macros/Go To Purge Spot"
G1 E-5 F400 ; retract 5mm of filament
M400
M98 P"/sys/usr/brush.g"
