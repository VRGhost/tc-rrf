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
    M566 A12 B12 C4 E120:120:120:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

    M201 A500 B500 C500 E6000:6000:6000:6000 X6000 Y6000 Z400

    M207 F2400 S10

    ; ----- apply_global_settings() END


if (param.T == 0)
    ; ---- T0
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:120:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

    M201 A500 B500 C500 E6000:6000:6000:6000 X6000 Y6000 Z400

    M207 F2400 S10

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P0 X300 Y300
    M201 P0 X3500 Y3500

    G10 P0 X20.3600 Y44.0400 Z-13.6000

        
    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_5 = 0
    while var.foreach_idx_5 < #tools[0].extruders
        
        set var.foreach_idx_5 = var.foreach_idx_5 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)


if (param.T == 1)
    ; ---- T1
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:120:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

    M201 A500 B500 C500 E6000:6000:6000:6000 X6000 Y6000 Z400

    M207 F2400 S10

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P1 X300 Y300
    M201 P1 X3500 Y3500

    G10 P1 X17.6000 Y44.5900 Z-13.3000

        
    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_6 = 0
    while var.foreach_idx_6 < #tools[1].extruders
        
        set var.foreach_idx_6 = var.foreach_idx_6 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)


if (param.T == 2)
    ; ---- T2
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:120:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

    M201 A500 B500 C500 E6000:6000:6000:6000 X6000 Y6000 Z400

    M207 F2400 S10

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3700, 'Y': 3700}}
    M566 P2 X300 Y300
    M201 P2 X3700 Y3700

    G10 P2 X-8.1800 Y39.4400 Z-13.2500

        
    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_7 = 0
    while var.foreach_idx_7 < #tools[2].extruders
        
        set var.foreach_idx_7 = var.foreach_idx_7 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)


if (param.T == 3)
    ; ---- T3
    ; ----- apply_global_settings()
    M566 A12 B12 C4 E120:120:120:120 X900 Y900 Z12

    M203 A7000 B7000 C5000 E5000:5000:5000:5000 X35000 Y35000 Z1200

    M201 A500 B500 C500 E6000:6000:6000:6000 X6000 Y6000 Z400

    M207 F2400 S10

    ; ----- apply_global_settings() END


        
    ; {'M566': {'X': 300, 'Y': 300}, 'M201': {'X': 3500, 'Y': 3500}}
    M566 P3 X300 Y300
    M201 P3 X3500 Y3500

    G10 P3 X20.3400 Y43.6800 Z-13.8000

        
    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_8 = 0
    while var.foreach_idx_8 < #tools[3].extruders
        
        set var.foreach_idx_8 = var.foreach_idx_8 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)


