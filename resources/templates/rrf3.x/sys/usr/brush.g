echo "Brush.g called"
;Drop Bed
;G91
;G1 Z2 F2000
;G90

;brush in
;G1 X-32.5 Y124 F50000
;G1 X-35.5 Y155 F50000
;G1 X-38.5 Y124 F50000
;G1 X-41.5 Y155 F50000

;Brush Out
;G1 X-41.5 Y155 F50000
;G1 X-32.5 Y150 F50000
;G1 X-41.5 Y145 F50000
;G1 X-32.5 Y140 F50000
;G1 X-41.5 Y135 F50000
;G1 X-32.5 Y130 F50000
;G1 X-41.5 Y125 F50000

{% import '__macros__/move.jinja' as move %}
{{ move.save_long_move(0, 0, 5) }}