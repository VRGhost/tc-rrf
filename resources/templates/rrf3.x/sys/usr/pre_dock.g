; This script is executed right before the nozzle is docked.

{% import '__macros__/heat.jinja' as heat %}

var can_extrude = 0
{{ heat.is_hot_enough_to_extrude('var.can_extrude') }}

if var.can_extrude <= 0
    echo "Too cold to extrude, skipping cleanup"
    M99 ; return

M98 P"/macros/Go To Purge Spot"
G1 E-5 F400 ; retract 5mm of filament
M400
M98 P"/sys/usr/brush.g"