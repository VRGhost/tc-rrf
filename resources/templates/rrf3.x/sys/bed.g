; Bed Mesh Leveling (G32 command)

var orig_tool = state.currentTool

T-1 ; Drop tool

G29

T{ var.orig_tool } ; restore the original tool

; Park the head
G1 X150 Y-49 F50000
