; Set tool-specific overrides
; Parameters:
;   T[tool_id : int] - target tool (<0 for "no tool")

;tool offsets
; !ESTIMATED! offsets for:
; V6-tool: X-9 Y39 Z-5
; Volcano-tool: X-9 Y39 Z-13.5
; Hemera-tool: X20 Y43.5 Z-6



if (param.T < 0)
    ; No tool configured
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:60:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E4800:4800:6000:4800 X35000 Y35000 Z1200

    M201 A500 B500 C500 E4000:4000:3000:4000 X6000 Y6000 Z400

    M207 F2400 S1

    ; ----- apply_global_settings() END


if (param.T == 0)
    ; ---- T0
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:60:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E4800:4800:6000:4800 X35000 Y35000 Z1200

    M201 A500 B500 C500 E4000:4000:3000:4000 X6000 Y6000 Z400

    M207 F2400 S1

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 350, 'Y': 350}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P0 X350 Y350
    M201 P0 X3500 Y3500

    G10 L1 P0 X20.6216 Y44.0059 Z-13.9500

        
    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_49 = 0
    while var.foreach_idx_49 < #tools[0].extruders
        
        set var.foreach_idx_49 = var.foreach_idx_49 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)


if (param.T == 1)
    ; ---- T1
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:60:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E4800:4800:6000:4800 X35000 Y35000 Z1200

    M201 A500 B500 C500 E4000:4000:3000:4000 X6000 Y6000 Z400

    M207 F2400 S1

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 350, 'Y': 350}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P1 X350 Y350
    M201 P1 X3500 Y3500

    G10 L1 P1 X17.5928 Y44.6365 Z-13.7400

        
    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_50 = 0
    while var.foreach_idx_50 < #tools[1].extruders
        
        set var.foreach_idx_50 = var.foreach_idx_50 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)


if (param.T == 2)
    ; ---- T2
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:60:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E4800:4800:6000:4800 X35000 Y35000 Z1200

    M201 A500 B500 C500 E4000:4000:3000:4000 X6000 Y6000 Z400

    M207 F2400 S1

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 550, 'Y': 550}, 'M201': {'X': 3700, 'Y': 3700}}
    M566 P2 X550 Y550
    M201 P2 X3700 Y3700

    G10 L1 P2 X-7.9780 Y39.1571 Z-13.4000

        
    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_51 = 0
    while var.foreach_idx_51 < #tools[2].extruders
        
        set var.foreach_idx_51 = var.foreach_idx_51 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)


if (param.T == 3)
    ; ---- T3
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:60:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E4800:4800:6000:4800 X35000 Y35000 Z1200

    M201 A500 B500 C500 E4000:4000:3000:4000 X6000 Y6000 Z400

    M207 F2400 S1

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 350, 'Y': 350}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P3 X350 Y350
    M201 P3 X3500 Y3500

    G10 L1 P3 X21.0260 Y43.9582 Z-13.6000

        
    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_52 = 0
    while var.foreach_idx_52 < #tools[3].extruders
        
        set var.foreach_idx_52 = var.foreach_idx_52 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)


