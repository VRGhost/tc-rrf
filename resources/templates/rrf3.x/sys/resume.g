; Resume macro file

{% from 'sys/usr/prime.g' import reset_global_prime_vars %}

; force large extrusions on next primings
{{ reset_global_prime_vars() }}

;prime nozzle
M98 P"/sys/usr/prime.g"

G1 R1 X0 Y0 Z2 F5000 		; go to 5mm above position of the last print move
G1 R1 X0 Y0 Z0 				; go back to the last print move
M83 						; relative extruder moves
G1 E3 F3600 				; extrude 3mm of filament