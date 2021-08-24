; This script is executed to prepare the nozzle for printing

M98 P"/macros/Go To Purge Spot"

G1 E20 F400 ; extrude 30mm of filament
M400
M98 P"/sys/usr/brush.g"
M400

M98 P"/macros/Go To Purge Spot"
