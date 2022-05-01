    ; A piece of code to put & restore XYZ coords for the tool





; Params:
;   S1 - push current values on the stack
;   S-1 - pop and apply current values

M400

if param.S = 1
    ; Save current pos on the stack
    if ( move.axes[0].userPosition < 0 ) || ( move.axes[1].userPosition < 0 )
        ; X or Y are negative - do not save such coords on the stack
        echo "Negative XY, not saving"
        M99
    if ( move.axes[0].userPosition > 300 ) || ( move.axes[1].userPosition > 200 )
        ; X or Y are negative - do not save such coords on the stack
        echo "Outside of the bed, not saving"
        M99
    if global.xyz_stack_current_depth == 3
        set global.xyz_stack_level_4_x = move.axes[0].userPosition
        set global.xyz_stack_level_4_y = move.axes[1].userPosition
        set global.xyz_stack_level_4_z = move.axes[2].userPosition
        set global.xyz_stack_current_depth = 4

    if global.xyz_stack_current_depth == 2
        set global.xyz_stack_level_3_x = move.axes[0].userPosition
        set global.xyz_stack_level_3_y = move.axes[1].userPosition
        set global.xyz_stack_level_3_z = move.axes[2].userPosition
        set global.xyz_stack_current_depth = 3

    if global.xyz_stack_current_depth == 1
        set global.xyz_stack_level_2_x = move.axes[0].userPosition
        set global.xyz_stack_level_2_y = move.axes[1].userPosition
        set global.xyz_stack_level_2_z = move.axes[2].userPosition
        set global.xyz_stack_current_depth = 2

    if global.xyz_stack_current_depth == 0
        set global.xyz_stack_level_1_x = move.axes[0].userPosition
        set global.xyz_stack_level_1_y = move.axes[1].userPosition
        set global.xyz_stack_level_1_z = move.axes[2].userPosition
        set global.xyz_stack_current_depth = 1

    if global.xyz_stack_current_depth == -1
        set global.xyz_stack_level_0_x = move.axes[0].userPosition
        set global.xyz_stack_level_0_y = move.axes[1].userPosition
        set global.xyz_stack_level_0_z = move.axes[2].userPosition
        set global.xyz_stack_current_depth = 0
elif param.S = -1
    ; Restore position from the stack
    ; ----- AVOID clashing with the TC walls
    if move.axes[1].homed && move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
        G1 Y200 F2500 ; slowly back out

    if global.xyz_stack_current_depth == 0
        M400
        G0 X{ global.xyz_stack_level_0_x } Y{ global.xyz_stack_level_0_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_0_z } F99999
        M400
        set global.xyz_stack_current_depth = -1

    if global.xyz_stack_current_depth == 1
        M400
        G0 X{ global.xyz_stack_level_1_x } Y{ global.xyz_stack_level_1_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_1_z } F99999
        M400
        set global.xyz_stack_current_depth = 0

    if global.xyz_stack_current_depth == 2
        M400
        G0 X{ global.xyz_stack_level_2_x } Y{ global.xyz_stack_level_2_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_2_z } F99999
        M400
        set global.xyz_stack_current_depth = 1

    if global.xyz_stack_current_depth == 3
        M400
        G0 X{ global.xyz_stack_level_3_x } Y{ global.xyz_stack_level_3_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_3_z } F99999
        M400
        set global.xyz_stack_current_depth = 2

    if global.xyz_stack_current_depth == 4
        M400
        G0 X{ global.xyz_stack_level_4_x } Y{ global.xyz_stack_level_4_y } F99999
        M400
        G1 Z{ global.xyz_stack_level_4_z } F99999
        M400
        set global.xyz_stack_current_depth = 3
else
    echo "Unsupported param.S =" ^ param.S
    M99
