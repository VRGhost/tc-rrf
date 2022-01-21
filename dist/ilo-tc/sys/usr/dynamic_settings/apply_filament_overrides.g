; Set fillament- and nozzle-specific overrides
; Parameters:
;   T[tool_id : int] - target tool
;   F[filament_name : string] - used filament
;   N[nozzle_diameter : float] - nozzle diameter
;
; Known filament names are: "PET", "PLA"



echo "Applying filament overrides for the Tool " ^ param.T ^ " with nozzle D=" ^ param.N ^ " and filament '" ^ param.F ^ "'"

if (param.T == 0) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.4, filament=PET)
    ; extruder_m221(0, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_9 = 0
    while var.foreach_idx_9 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_9] } S93
        set var.foreach_idx_9 = var.foreach_idx_9 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R-0.0100
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=PET)
    ; extruder_m221(0, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_10 = 0
    while var.foreach_idx_10 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_10] } S93
        set var.foreach_idx_10 = var.foreach_idx_10 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R-0.0100
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=0, nozzle_d=0.8, filament=PET)
    ; extruder_m221(0, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_11 = 0
    while var.foreach_idx_11 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_11] } S93
        set var.foreach_idx_11 = var.foreach_idx_11 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R-0.0100
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(0, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_12 = 0
    while var.foreach_idx_12 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_12] } S89
        set var.foreach_idx_12 = var.foreach_idx_12 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(0, {'S': 73}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_13 = 0
    while var.foreach_idx_13 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_13] } S73
        set var.foreach_idx_13 = var.foreach_idx_13 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PET)
    ; extruder_m221(1, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_14 = 0
    while var.foreach_idx_14 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_14] } S93
        set var.foreach_idx_14 = var.foreach_idx_14 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R-0.0100
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=PET)
    ; extruder_m221(1, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_15 = 0
    while var.foreach_idx_15 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_15] } S93
        set var.foreach_idx_15 = var.foreach_idx_15 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R-0.0100
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=1, nozzle_d=0.8, filament=PET)
    ; extruder_m221(1, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_16 = 0
    while var.foreach_idx_16 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_16] } S93
        set var.foreach_idx_16 = var.foreach_idx_16 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R-0.0100
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(1, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_17 = 0
    while var.foreach_idx_17 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_17] } S89
        set var.foreach_idx_17 = var.foreach_idx_17 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(1, {'S': 73}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_18 = 0
    while var.foreach_idx_18 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_18] } S73
        set var.foreach_idx_18 = var.foreach_idx_18 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PET)
    ; extruder_m221(2, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_19 = 0
    while var.foreach_idx_19 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_19] } S93
        set var.foreach_idx_19 = var.foreach_idx_19 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=PET)
    ; extruder_m221(2, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_20 = 0
    while var.foreach_idx_20 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_20] } S93
        set var.foreach_idx_20 = var.foreach_idx_20 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=2, nozzle_d=0.8, filament=PET)
    ; extruder_m221(2, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_21 = 0
    while var.foreach_idx_21 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_21] } S93
        set var.foreach_idx_21 = var.foreach_idx_21 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(2, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_22 = 0
    while var.foreach_idx_22 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_22] } S89
        set var.foreach_idx_22 = var.foreach_idx_22 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 F2000 S2 Z0.6000
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(2, {'S': 73}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_23 = 0
    while var.foreach_idx_23 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_23] } S73
        set var.foreach_idx_23 = var.foreach_idx_23 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 F2000 S2 Z0.6000
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PET)
    ; extruder_m221(3, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_24 = 0
    while var.foreach_idx_24 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_24] } S93
        set var.foreach_idx_24 = var.foreach_idx_24 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R-0.0100
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=PET)
    ; extruder_m221(3, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_25 = 0
    while var.foreach_idx_25 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_25] } S93
        set var.foreach_idx_25 = var.foreach_idx_25 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R-0.0100
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=3, nozzle_d=0.8, filament=PET)
    ; extruder_m221(3, {'S': 93}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_26 = 0
    while var.foreach_idx_26 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_26] } S93
        set var.foreach_idx_26 = var.foreach_idx_26 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R-0.0100
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(3, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_27 = 0
    while var.foreach_idx_27 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_27] } S89
        set var.foreach_idx_27 = var.foreach_idx_27 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(3, {'S': 73}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_28 = 0
    while var.foreach_idx_28 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_28] } S73
        set var.foreach_idx_28 = var.foreach_idx_28 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 F2700 S0.2500 Z0.6000
    ; apply_tool_mode() END



