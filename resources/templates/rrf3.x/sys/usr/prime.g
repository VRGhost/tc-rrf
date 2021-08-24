; This script is executed to prepare the nozzle for printing

{% import '__macros__/heat.jinja' as heat %}

var can_extrude = 0
{{ heat.is_hot_enough_to_extrude('var.can_extrude') }}

if var.can_extrude <= 0
    echo "Too cold to extrude, skipping priming"
    M99 ; return

M98 P"/macros/Go To Purge Spot"

G1 E20 F400 ; extrude 30mm of filament
M400
M98 P"/sys/usr/brush.g"
M400

M98 P"/macros/Go To Purge Spot"