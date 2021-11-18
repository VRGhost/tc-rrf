; stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

{% import '__macros__/move.jinja' as move %}

G29 S2 ; Disable mesh bed compensation (makes XY moves faster)
T-1


if move.axes[{{ axis.Z.index }}].userPosition < 280
    ; Lower the bed
    G0 Z280