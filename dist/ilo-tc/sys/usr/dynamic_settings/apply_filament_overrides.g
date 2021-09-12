; Set fillament- and nozzle-specific overrides
; Parameters:
;   T[tool_id : int] - target tool
;   F[filament_name : string] - used filament
;   N[nozzle_diameter : float] - nozzle diameter
;
; Known filament names are: "PET", "PLA"



echo "Applying filament overrides for the Tool " ^ param.T ^ " with nozzle D=" ^ param.N ^ " and filament '" ^ param.F ^ "'"

var extrude_factor = 100 ; Default factor



if param.F == "PET"
    
    if (param.N < 0.60000)
        ; Nozzle diameter 0.4
        set var.extrude_factor = 80 ; Real factor = 0.8097
    
    if (param.N >= 0.60000)
        ; Nozzle diameter 0.8
        set var.extrude_factor = 56 ; Real factor = 0.5612
    


if param.F == "PLA"
    
    if (param.N < 0.50000)
        ; Nozzle diameter 0.4
        set var.extrude_factor = 90 ; Real factor = 0.9
    
    if (param.N >= 0.50000)
        ; Nozzle diameter 0.6
        set var.extrude_factor = 86 ; Real factor = 0.86641
    


echo "Using extrude factor " ^ var.extrude_factor


; util.foreach(tools[{{ param.T }}].extruders)

var foreach_idx_5 = 0
while var.foreach_idx_5 < #tools[{{ param.T }}].extruders
    
    M221 S{var.extrude_factor} D{ tools[{{ param.T }}].extruders[var.foreach_idx_5] }

    set var.foreach_idx_5 = var.foreach_idx_5 + 1

; end util.foreach()