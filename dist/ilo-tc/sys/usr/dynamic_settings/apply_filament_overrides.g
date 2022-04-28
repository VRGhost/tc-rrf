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
    ; extruder_m221(0, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_21 = 0
    while var.foreach_idx_21 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_21] } S98
        set var.foreach_idx_21 = var.foreach_idx_21 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R0 S0.5000 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=PET)
    ; extruder_m221(0, {'S': 99}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_22 = 0
    while var.foreach_idx_22 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_22] } S99
        set var.foreach_idx_22 = var.foreach_idx_22 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R0 S0.5000 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=0, nozzle_d=0.8, filament=PET)
    ; extruder_m221(0, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_23 = 0
    while var.foreach_idx_23 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_23] } S98
        set var.foreach_idx_23 = var.foreach_idx_23 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 R0 S0.5000 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(0, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_24 = 0
    while var.foreach_idx_24 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_24] } S89
        set var.foreach_idx_24 = var.foreach_idx_24 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 F2000 S0.3500 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(0, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_25 = 0
    while var.foreach_idx_25 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_25] } S89
        set var.foreach_idx_25 = var.foreach_idx_25 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 F2000 S0.3500 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 0) && (param.F == "NYLON") && (true)
    ; apply_tool_mode(tool=0, nozzle_d=0.6, filament=NYLON)
    ; extruder_m221(0, {'S': 67}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(0)
    ; util.foreach(tools[0].extruders)

    var foreach_idx_26 = 0
    while var.foreach_idx_26 < #tools[0].extruders
        M221 D{ tools[0].extruders[var.foreach_idx_26] } S67
        set var.foreach_idx_26 = var.foreach_idx_26 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(0)

    ; extruder_m221() END
    M207 P0 F2000 S0.3500 Z0.6000
    set global.t0_babystep = global.t0_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PET)
    ; extruder_m221(1, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_27 = 0
    while var.foreach_idx_27 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_27] } S98
        set var.foreach_idx_27 = var.foreach_idx_27 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R0 S0.5000 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=PET)
    ; extruder_m221(1, {'S': 99}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_28 = 0
    while var.foreach_idx_28 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_28] } S99
        set var.foreach_idx_28 = var.foreach_idx_28 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R0 S0.5000 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=1, nozzle_d=0.8, filament=PET)
    ; extruder_m221(1, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_29 = 0
    while var.foreach_idx_29 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_29] } S98
        set var.foreach_idx_29 = var.foreach_idx_29 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 R0 S0.5000 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(1, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_30 = 0
    while var.foreach_idx_30 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_30] } S89
        set var.foreach_idx_30 = var.foreach_idx_30 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 F2000 S0.3500 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(1, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_31 = 0
    while var.foreach_idx_31 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_31] } S89
        set var.foreach_idx_31 = var.foreach_idx_31 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 F2000 S0.3500 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 1) && (param.F == "NYLON") && (true)
    ; apply_tool_mode(tool=1, nozzle_d=0.6, filament=NYLON)
    ; extruder_m221(1, {'S': 67}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(1)
    ; util.foreach(tools[1].extruders)

    var foreach_idx_32 = 0
    while var.foreach_idx_32 < #tools[1].extruders
        M221 D{ tools[1].extruders[var.foreach_idx_32] } S67
        set var.foreach_idx_32 = var.foreach_idx_32 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(1)

    ; extruder_m221() END
    M207 P1 F2000 S0.3500 Z0.6000
    set global.t1_babystep = global.t1_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PET)
    ; extruder_m221(2, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_33 = 0
    while var.foreach_idx_33 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_33] } S98
        set var.foreach_idx_33 = var.foreach_idx_33 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100 S2 Z0.6000
    set global.t2_babystep = global.t2_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=PET)
    ; extruder_m221(2, {'S': 99}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_34 = 0
    while var.foreach_idx_34 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_34] } S99
        set var.foreach_idx_34 = var.foreach_idx_34 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100 S2 Z0.6000
    set global.t2_babystep = global.t2_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=2, nozzle_d=0.8, filament=PET)
    ; extruder_m221(2, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_35 = 0
    while var.foreach_idx_35 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_35] } S98
        set var.foreach_idx_35 = var.foreach_idx_35 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 R-0.0100 S2 Z0.6000
    set global.t2_babystep = global.t2_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(2, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_36 = 0
    while var.foreach_idx_36 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_36] } S89
        set var.foreach_idx_36 = var.foreach_idx_36 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 F1500 S0.5000 Z0.6000
    set global.t2_babystep = global.t2_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(2, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_37 = 0
    while var.foreach_idx_37 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_37] } S89
        set var.foreach_idx_37 = var.foreach_idx_37 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 F1500 S0.5000 Z0.6000
    set global.t2_babystep = global.t2_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 2) && (param.F == "NYLON") && (true)
    ; apply_tool_mode(tool=2, nozzle_d=0.6, filament=NYLON)
    ; extruder_m221(2, {'S': 67}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(2)
    ; util.foreach(tools[2].extruders)

    var foreach_idx_38 = 0
    while var.foreach_idx_38 < #tools[2].extruders
        M221 D{ tools[2].extruders[var.foreach_idx_38] } S67
        set var.foreach_idx_38 = var.foreach_idx_38 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(2)

    ; extruder_m221() END
    M207 P2 
    set global.t2_babystep = global.t2_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N < 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PET)
    ; extruder_m221(3, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_39 = 0
    while var.foreach_idx_39 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_39] } S98
        set var.foreach_idx_39 = var.foreach_idx_39 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R0 S0.5000 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N >= 0.50000) && (param.N < 0.70000)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=PET)
    ; extruder_m221(3, {'S': 99}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_40 = 0
    while var.foreach_idx_40 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_40] } S99
        set var.foreach_idx_40 = var.foreach_idx_40 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R0 S0.5000 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PET") && (param.N >= 0.70000)
    ; apply_tool_mode(tool=3, nozzle_d=0.8, filament=PET)
    ; extruder_m221(3, {'S': 98}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_41 = 0
    while var.foreach_idx_41 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_41] } S98
        set var.foreach_idx_41 = var.foreach_idx_41 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 R0 S0.5000 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.04
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N < 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.4, filament=PLA)
    ; extruder_m221(3, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_42 = 0
    while var.foreach_idx_42 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_42] } S89
        set var.foreach_idx_42 = var.foreach_idx_42 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 F2000 S0.3500 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "PLA") && (param.N >= 0.50000)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=PLA)
    ; extruder_m221(3, {'S': 89}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_43 = 0
    while var.foreach_idx_43 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_43] } S89
        set var.foreach_idx_43 = var.foreach_idx_43 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 F2000 S0.3500 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.0
    ; apply_tool_mode() END


if (param.T == 3) && (param.F == "NYLON") && (true)
    ; apply_tool_mode(tool=3, nozzle_d=0.6, filament=NYLON)
    ; extruder_m221(3, {'S': 67}) ( Set extrude factor override percentage )

    ; tools.foreach_extruder(3)
    ; util.foreach(tools[3].extruders)

    var foreach_idx_44 = 0
    while var.foreach_idx_44 < #tools[3].extruders
        M221 D{ tools[3].extruders[var.foreach_idx_44] } S67
        set var.foreach_idx_44 = var.foreach_idx_44 + 1

    ; end util.foreach()
    ; end tools.foreach_extruder(3)

    ; extruder_m221() END
    M207 P3 F2000 S0.3500 Z0.6000
    set global.t3_babystep = global.t3_babystep + 0.0
    ; apply_tool_mode() END



