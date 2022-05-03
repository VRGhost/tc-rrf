; stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

{% import '__macros__/move.jinja' as move %}

G29 S2 ; Disable mesh bed compensation (makes XY moves faster)
T-1

; Turn off extruders
M568 P0 A0
M568 P1 A0
M568 P2 A0
M568 P3 A0
; Turn off bed header
M140 P0 S-273.15

if move.axes[{{ axis.Z.index }}].userPosition < 280
    ; Lower the bed
    G0 Z280