; This script is executed to prepare the nozzle for printing






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
    ; "Too cold to extrude, skipping priming"
    M99 ; return

var is_first_use = false


; ---- check_and_mark_first_nozzle_use(0)
if state.currentTool == 0 && mod(global.prime_first_tool_use, 2) != 0
    ; The tool ID is not present in the global state. This is the first use of the tool
    set global.prime_first_tool_use = global.prime_first_tool_use * 2
    set var.is_first_use = true
; ---- check_and_mark_first_nozzle_use() END


; ---- check_and_mark_first_nozzle_use(1)
if state.currentTool == 1 && mod(global.prime_first_tool_use, 3) != 0
    ; The tool ID is not present in the global state. This is the first use of the tool
    set global.prime_first_tool_use = global.prime_first_tool_use * 3
    set var.is_first_use = true
; ---- check_and_mark_first_nozzle_use() END


; ---- check_and_mark_first_nozzle_use(2)
if state.currentTool == 2 && mod(global.prime_first_tool_use, 5) != 0
    ; The tool ID is not present in the global state. This is the first use of the tool
    set global.prime_first_tool_use = global.prime_first_tool_use * 5
    set var.is_first_use = true
; ---- check_and_mark_first_nozzle_use() END


; ---- check_and_mark_first_nozzle_use(3)
if state.currentTool == 3 && mod(global.prime_first_tool_use, 7) != 0
    ; The tool ID is not present in the global state. This is the first use of the tool
    set global.prime_first_tool_use = global.prime_first_tool_use * 7
    set var.is_first_use = true
; ---- check_and_mark_first_nozzle_use() END



M98 P"/macros/Go To Purge Spot"

G1 E{ var.is_first_use ? 90 : 40 } F400 ; extrude 30mm of filament
M400
G4 S{ global.prime_extrude_delay } ; wait
M98 P"/sys/usr/brush.g"
M400
G10 ; retract
