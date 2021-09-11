; Bed Mesh Leveling (G32 command)

; This macro saves and restores currently used tool



var old_tool_0 = -1

if !move.axes[5].homed
    abort "Coupler (C) is not homed."


set var.old_tool_0 = state.currentTool
T-1



G29



T{ var.old_tool_0 }
