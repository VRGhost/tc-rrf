; All machine-global variables






; ---- see /sys/usr/maybe_brush.g
global maybe_brush_last_tool = -100
global maybe_brush_last_time = -99999


; ---- declare_global_prime_vars
global prime_extrude_delay = 2 ; seconds
global prime_first_tool_use = 1 ; this int is used to mark what tool hadn't been initially primed


; ---- declare_global_babystep_vars
global t0_babystep = 0.0
global t1_babystep = 0.0
global t2_babystep = 0.0
global t3_babystep = 0.0




; XYZ stack globals

global xyz_stack_current_depth = -1

global xyz_stack_level_0_x = 0
global xyz_stack_level_0_y = 0
global xyz_stack_level_0_z = 99999
global xyz_stack_level_1_x = 0
global xyz_stack_level_1_y = 0
global xyz_stack_level_1_z = 99999
global xyz_stack_level_2_x = 0
global xyz_stack_level_2_y = 0
global xyz_stack_level_2_z = 99999
global xyz_stack_level_3_x = 0
global xyz_stack_level_3_y = 0
global xyz_stack_level_3_z = 99999
global xyz_stack_level_4_x = 0
global xyz_stack_level_4_y = 0
global xyz_stack_level_4_z = 99999


