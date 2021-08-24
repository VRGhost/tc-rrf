; This script maybe calls brush (if it hadn't been called too long ago)

if global.maybe_brush_last_tool != state.currentTool || (global.maybe_brush_last_time + 30) < state.upTime
    M98 P"/sys/usr/brush.g"

    set global.maybe_brush_last_tool = state.currentTool
    set global.maybe_brush_last_time = state.upTime
else
    echo "maybe_brush.g: skip"
