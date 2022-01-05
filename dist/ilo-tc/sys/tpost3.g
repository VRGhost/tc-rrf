; tpost3.g
; called after tool 3 has been selected



;heatup

var curToolTemp = -273

; ------ get_nozzle_temp(var.curToolTemp, 3)
set var.curToolTemp = -273


var cur_tool_heater_idx_1 = 0
var cur_heater_idx_0 = -1

if 3 >= 0
    ; Valid tool ID
    while var.cur_tool_heater_idx_1 < #tools[3].heaters
        set var.cur_heater_idx_0 = tools[3].heaters[var.cur_tool_heater_idx_1]
        
        set var.curToolTemp = max(var.curToolTemp, heat.heaters[var.cur_heater_idx_0].current)

        set var.cur_tool_heater_idx_1 = var.cur_tool_heater_idx_1 + 1


; ------ get_nozzle_temp() END


var targetToolTemp = -273

set var.targetToolTemp = -273
; ------ get_target_tool_temp(var.targetToolTemp, 3)


var cur_tool_heater_idx_3 = 0
var cur_heater_idx_2 = -1

if 3 >= 0
    ; Valid tool ID
    while var.cur_tool_heater_idx_3 < #tools[3].heaters
        set var.cur_heater_idx_2 = tools[3].heaters[var.cur_tool_heater_idx_3]
        
        if heat.heaters[var.cur_heater_idx_2].state == "active"
            set var.targetToolTemp = max(var.targetToolTemp, heat.heaters[var.cur_heater_idx_2].active)
        if heat.heaters[var.cur_heater_idx_2].state == "standby"
            set var.targetToolTemp = max(var.targetToolTemp, heat.heaters[var.cur_heater_idx_2].standby)

        set var.cur_tool_heater_idx_3 = var.cur_tool_heater_idx_3 + 1


; ------ get_target_tool_temp() END



if var.curToolTemp < 55 && var.targetToolTemp > 100
    ; Sleep for a little bit
    echo "Waiting for 15 seconds."
    G4 S15

M116 P3

M106 R2 ; restore print cooling fan speed

;prime nozzle
M98 P"/sys/usr/prime.g"
