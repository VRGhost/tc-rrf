; Set fillament- and nozzle-specific overrides
; Parameters:
;   T[tool_id : int] - target tool
;   F[filament_name : string] - used filament
;   N[nozzle_diameter : float] - nozzle diameter
;
; Known filament names are: "PET", "PLA"



echo "Applying filament overrides for the Tool " ^ param.T ^ " with nozzle D=" ^ param.N ^ " and filament '" ^ param.F ^ "'"

if (param.T == 0) && (param.F == "PET") && (param.N < 0.60000)
    ; apply_tool_mode(tool=0, nozzle_d=0.4, filament=PET)
    ; extruder_m221(0, {'S': 93})

    ; util.foreach(tools[0].extruders)

    var foreach_idx_5 = 0
    while var.foreach_idx_5 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_5] } S93
        set var.foreach_idx_5 = var.foreach_idx_5 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P0 R-0.0100
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PET") && (param.N >= 0.60000)
    ; apply_tool_mode(tool=0, nozzle_d=0.8, filament=PET)
    ; extruder_m221(0, {'S': 60})

    ; util.foreach(tools[0].extruders)

    var foreach_idx_6 = 0
    while var.foreach_idx_6 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_6] } S60
        set var.foreach_idx_6 = var.foreach_idx_6 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P0 R-0.0100
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(0, {'S': 89})

    ; util.foreach(tools[0].extruders)

    var foreach_idx_7 = 0
    while var.foreach_idx_7 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_7] } S89
        set var.foreach_idx_7 = var.foreach_idx_7 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P0 F2700 R-0.0100 S0.2500 Z0.0750
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(0, {'S': 87})

    ; util.foreach(tools[0].extruders)

    var foreach_idx_8 = 0
    while var.foreach_idx_8 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_8] } S87
        set var.foreach_idx_8 = var.foreach_idx_8 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P0 F2700 R-0.0100 S0.2500 Z0.0750
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N < 0.60000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PET)
    ; extruder_m221(1, {'S': 93})

    ; util.foreach(tools[1].extruders)

    var foreach_idx_9 = 0
    while var.foreach_idx_9 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_9] } S93
        set var.foreach_idx_9 = var.foreach_idx_9 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P1 R-0.0100
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N >= 0.60000)
    ; apply_tool_mode(tool=1, nozzle_d=0.8, filament=PET)
    ; extruder_m221(1, {'S': 60})

    ; util.foreach(tools[1].extruders)

    var foreach_idx_10 = 0
    while var.foreach_idx_10 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_10] } S60
        set var.foreach_idx_10 = var.foreach_idx_10 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P1 R-0.0100
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(1, {'S': 89})

    ; util.foreach(tools[1].extruders)

    var foreach_idx_11 = 0
    while var.foreach_idx_11 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_11] } S89
        set var.foreach_idx_11 = var.foreach_idx_11 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P1 F2700 R-0.0100 S0.2500 Z0.0750
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(1, {'S': 87})

    ; util.foreach(tools[1].extruders)

    var foreach_idx_12 = 0
    while var.foreach_idx_12 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_12] } S87
        set var.foreach_idx_12 = var.foreach_idx_12 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P1 F2700 R-0.0100 S0.2500 Z0.0750
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N < 0.60000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PET)
    ; extruder_m221(2, {'S': 93})

    ; util.foreach(tools[2].extruders)

    var foreach_idx_13 = 0
    while var.foreach_idx_13 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_13] } S93
        set var.foreach_idx_13 = var.foreach_idx_13 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P2 R-0.0100
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N >= 0.60000)
    ; apply_tool_mode(tool=2, nozzle_d=0.8, filament=PET)
    ; extruder_m221(2, {'S': 60})

    ; util.foreach(tools[2].extruders)

    var foreach_idx_14 = 0
    while var.foreach_idx_14 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_14] } S60
        set var.foreach_idx_14 = var.foreach_idx_14 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P2 R-0.0100
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(2, {'S': 89})

    ; util.foreach(tools[2].extruders)

    var foreach_idx_15 = 0
    while var.foreach_idx_15 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_15] } S89
        set var.foreach_idx_15 = var.foreach_idx_15 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P2 F2000 R-0.5000 S10 Z0.0750
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(2, {'S': 87})

    ; util.foreach(tools[2].extruders)

    var foreach_idx_16 = 0
    while var.foreach_idx_16 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_16] } S87
        set var.foreach_idx_16 = var.foreach_idx_16 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P2 F2000 R-0.5000 S10 Z0.0750
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N < 0.60000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PET)
    ; extruder_m221(3, {'S': 93})

    ; util.foreach(tools[3].extruders)

    var foreach_idx_17 = 0
    while var.foreach_idx_17 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_17] } S93
        set var.foreach_idx_17 = var.foreach_idx_17 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P3 R-0.0100
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N >= 0.60000)
    ; apply_tool_mode(tool=3, nozzle_d=0.8, filament=PET)
    ; extruder_m221(3, {'S': 60})

    ; util.foreach(tools[3].extruders)

    var foreach_idx_18 = 0
    while var.foreach_idx_18 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_18] } S60
        set var.foreach_idx_18 = var.foreach_idx_18 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P3 R-0.0100
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(3, {'S': 89})

    ; util.foreach(tools[3].extruders)

    var foreach_idx_19 = 0
    while var.foreach_idx_19 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_19] } S89
        set var.foreach_idx_19 = var.foreach_idx_19 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P3 F2000 R-0.5000 S10 Z0.0750
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(3, {'S': 87})

    ; util.foreach(tools[3].extruders)

    var foreach_idx_20 = 0
    while var.foreach_idx_20 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_20] } S87
        set var.foreach_idx_20 = var.foreach_idx_20 + 1

    ; end util.foreach()

    ; extruder_m221() END
    M207 P3 F2000 R-0.5000 S10 Z0.0750
    ; apply_tool_mode() END



