; homex.g
; called to home the x axis



var y_idx = -1
;----- find_axis_id("Y", var.y_idx)

var axis_iter_4 = 0
var find_success_5 = 0 ; 0 - not found, 1 - found

while var.axis_iter_4 < #move.axes
    if move.axes[var.axis_iter_4].letter == "Y"
        set var.find_success_5 = 1
        set var.y_idx = var.axis_iter_4
        break
    set var.axis_iter_4 = var.axis_iter_4 + 1

if var.find_success_5 == 0
    abort "Failed to find Y axis"

;----- find_axis_id("Y", var.y_idx) END

if !move.axes[var.y_idx].homed
    M98 P"homey.g"          ; Home Y
    M400
else
    ; Avoid accidentally clashing with the tools/Z column
    ; ----- AVOID clashing with the TC walls
    if move.axes[1].userPosition > 205 ; if Y > 205 (somewhere in the TC docking area)
        G1 Y200 F2500 ; slowly back out


if state.currentTool >= 0
    abort "Refusing to home X with tool attached."

G91 							; use relative positioning

G1 H2 X0.5 Y-0.5 F10000			; energise motors to ensure they are not stalled

M400 							; make sure everything has stopped before we change the motor currents
M913 X20 Y20 					; drop motor currents to 25%
M915 H200 X Y S3 R0 F0 			; set X and Y to sensitivity 3, do nothing when stall, unfiltered

G1 H2 Z3 F5000					; lift Z 3mm
G1 H1 X-400 F3000 				; move left 400mm, stopping at the endstop
G1 H1 X2 F2000 					; move away from end
G1 H2 Z-3 F1200					; lower Z
G90 							; back to absolute positioning

M400 							; make sure everything has stopped before we reset the motor currents
M913 X100 Y100 					; motor currents back to 100%
