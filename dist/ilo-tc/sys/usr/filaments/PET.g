; M409 K"sensors" F"d99vn"

; --- amend_current_tool_offsets(0,  0, 0.2)
if state.currentTool >= 0
    echo "Amending offsets for the T" ^ state.currentTool
    M98 P"/sys/usr/reset_tool_offsets.g" ; Ensure that all offsets are set to stock
    var new_x = tools[state.currentTool].offsets[0] + 0
    var new_y = tools[state.currentTool].offsets[1] + 0
    var new_z = tools[state.currentTool].offsets[2] + 0.2
    
    G10 X{{var.new_x}} Y{{var.new_y}} Z{{var.new_z}}
    
else
    echo "amend_current_tool_offsets: No tool is currently selected"
; --- amend_current_tool_offsets() END
