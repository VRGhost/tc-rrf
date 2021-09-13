; stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

G29 S2 ; Disable mesh bed compensation (makes XY moves faster)
T-1
M0      ; all heaters off