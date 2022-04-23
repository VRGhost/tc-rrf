; This script maybe calls brush (if it hadn't been called too long ago)
; This is meant to be called periodically while printing






;;;;; Maybe_brush disabled for now - confirming if I'm getting inconsistent print quality due to retrations
;if global.maybe_brush_last_tool != state.currentTool || (global.maybe_brush_last_time + 600) < state.upTime
;    G10 ; retract
;    M98 P"/sys/usr/brush.g"
;    G11 ; unretract
