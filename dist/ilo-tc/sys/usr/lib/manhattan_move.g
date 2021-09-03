; Manhattan move - move to X, Y but while moving around the bed




; ##### find_nearest_manhattan_point
;       Finds the point on the (min x, min y), (max x, max y) rectangle
;       that is nearest to the (target x, target y)







; Params:
;   X, Y - target coords
;   Z - delta Z to raise/lower the bed by
;   F - move speed




G91
G0 Z{param.Z}
G90

;
;           P2 * < < < < < < < < < < < < < < < < < < < < < * P1
;              V  +----------------------------------------^-----------+
;                 |                                        ^           |
;              V  |          BED                           * P0 (src)  |
;                 |                                                    |
;              V  |                                                    |
;                 |                                                    |
;              V  |                                                    |
;                 |                                                    |
;              V  |                                                    |
;                 |                                                    |
;              V  |                                                    |
;                 |     * P6 (dst)                                     |
;              V  |     ^                                              |
;                 +-----^----------------------------------------------+
;         P4   * > > > >*  P5








var x_axis_idx = -1
;----- find_axis_id("X", var.x_axis_idx)

var axis_iter_12 = 0
var find_success_13 = 0 ; 0 - not found, 1 - found

while var.axis_iter_12 < #move.axes
    if move.axes[var.axis_iter_12].letter == "X"
        set var.find_success_13 = 1
        set var.x_axis_idx = var.axis_iter_12
        break
    set var.axis_iter_12 = var.axis_iter_12 + 1

if var.find_success_13 == 0
    abort "Failed to find X axis"

;----- find_axis_id("X", var.x_axis_idx) END
var y_axis_idx = -1
;----- find_axis_id("Y", var.y_axis_idx)

var axis_iter_14 = 0
var find_success_15 = 0 ; 0 - not found, 1 - found

while var.axis_iter_14 < #move.axes
    if move.axes[var.axis_iter_14].letter == "Y"
        set var.find_success_15 = 1
        set var.y_axis_idx = var.axis_iter_14
        break
    set var.axis_iter_14 = var.axis_iter_14 + 1

if var.find_success_15 == 0
    abort "Failed to find Y axis"

;----- find_axis_id("Y", var.y_axis_idx) END

var src_x = move.axes[var.x_axis_idx].userPosition
var src_y = move.axes[var.y_axis_idx].userPosition

var p1_x = 0
var p1_y = 0

var p2_x = 0
var p2_y = 0

var p3_x = 0
var p3_y = 0

var p4_x = 0
var p4_y = 0

var p5_x = 0
var p5_y = 0

var dst_x = param.X
var dst_y = param.Y




; ---- find_nearest_manhattan_point(var.p1_x, var.p1_y, var.src_x, var.src_y, 0, 0, 300, 200)

var dx_16 = 0
var dy_17 = 0

; Step 1 - move to the nearest edge
; --- Find the minimum dx/dy to move to the rectangle

; ----- Find min dx (by abs)
set var.dx_16 = 0 - var.src_x
if abs(var.dx_16) > abs(300 - var.src_x)
    set var.dx_16 = 300 - var.src_x

; ------ Find min dy (by abs)
set var.dy_17 = 0 - var.src_y
if abs(var.dy_17) > abs(200 - var.src_y)
    set var.dy_17 = 200 - var.src_y

; --- Pick the side with minimum delta
if abs(var.dx_16) > abs(var.dy_17)
    set var.dx_16 = 0
else
    set var.dy_17 = 0

set var.p1_x = var.src_x + var.dx_16
set var.p1_y = var.src_y + var.dy_17

; ---- find_nearest_manhattan_point() END

; ---- find_nearest_manhattan_point(var.p5_x, var.p5_y, var.dst_x, var.dst_y, 0, 0, 300, 200)

var dx_18 = 0
var dy_19 = 0

; Step 1 - move to the nearest edge
; --- Find the minimum dx/dy to move to the rectangle

; ----- Find min dx (by abs)
set var.dx_18 = 0 - var.dst_x
if abs(var.dx_18) > abs(300 - var.dst_x)
    set var.dx_18 = 300 - var.dst_x

; ------ Find min dy (by abs)
set var.dy_19 = 0 - var.dst_y
if abs(var.dy_19) > abs(200 - var.dst_y)
    set var.dy_19 = 200 - var.dst_y

; --- Pick the side with minimum delta
if abs(var.dx_18) > abs(var.dy_19)
    set var.dx_18 = 0
else
    set var.dy_19 = 0

set var.p5_x = var.dst_x + var.dx_18
set var.p5_y = var.dst_y + var.dy_19

; ---- find_nearest_manhattan_point() END


; ---- find_nearest_manhattan_corner(var.p2_x, var.p2_y, var.p1_x, var.p1_y, 0, 0, 300, 200)

var cur_min_dist_20 = 99999999999
var cur_check_dist_21 = 0

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_21, 0, 0, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_21 = ( (0 - var.p1_x)*(0 - var.p1_x) ) + ( (0 - var.p1_y)*(0 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_20 > var.cur_check_dist_21 && ( 0 == var.p1_x || 0 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 0
    set var.p2_y = 0
    set var.cur_min_dist_20 = var.cur_check_dist_21
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_21, 0, 200, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_21 = ( (0 - var.p1_x)*(0 - var.p1_x) ) + ( (200 - var.p1_y)*(200 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_20 > var.cur_check_dist_21 && ( 0 == var.p1_x || 200 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 0
    set var.p2_y = 200
    set var.cur_min_dist_20 = var.cur_check_dist_21

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_21, 300, 0, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_21 = ( (300 - var.p1_x)*(300 - var.p1_x) ) + ( (0 - var.p1_y)*(0 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_20 > var.cur_check_dist_21 && ( 300 == var.p1_x || 0 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 300
    set var.p2_y = 0
    set var.cur_min_dist_20 = var.cur_check_dist_21
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_21, 300, 200, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_21 = ( (300 - var.p1_x)*(300 - var.p1_x) ) + ( (200 - var.p1_y)*(200 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_20 > var.cur_check_dist_21 && ( 300 == var.p1_x || 200 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 300
    set var.p2_y = 200
    set var.cur_min_dist_20 = var.cur_check_dist_21



; ---- find_nearest_manhattan_corner() END

; ---- find_nearest_manhattan_corner(var.p4_x, var.p4_y, var.p5_x, var.p5_y, 0, 0, 300, 200)

var cur_min_dist_22 = 99999999999
var cur_check_dist_23 = 0

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_23, 0, 0, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_23 = ( (0 - var.p5_x)*(0 - var.p5_x) ) + ( (0 - var.p5_y)*(0 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_22 > var.cur_check_dist_23 && ( 0 == var.p5_x || 0 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 0
    set var.p4_y = 0
    set var.cur_min_dist_22 = var.cur_check_dist_23
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_23, 0, 200, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_23 = ( (0 - var.p5_x)*(0 - var.p5_x) ) + ( (200 - var.p5_y)*(200 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_22 > var.cur_check_dist_23 && ( 0 == var.p5_x || 200 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 0
    set var.p4_y = 200
    set var.cur_min_dist_22 = var.cur_check_dist_23

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_23, 300, 0, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_23 = ( (300 - var.p5_x)*(300 - var.p5_x) ) + ( (0 - var.p5_y)*(0 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_22 > var.cur_check_dist_23 && ( 300 == var.p5_x || 0 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 300
    set var.p4_y = 0
    set var.cur_min_dist_22 = var.cur_check_dist_23
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_23, 300, 200, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_23 = ( (300 - var.p5_x)*(300 - var.p5_x) ) + ( (200 - var.p5_y)*(200 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_22 > var.cur_check_dist_23 && ( 300 == var.p5_x || 200 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 300
    set var.p4_y = 200
    set var.cur_min_dist_22 = var.cur_check_dist_23



; ---- find_nearest_manhattan_corner() END



; ---- find_manhattan_midpoint(var.p3_x, var.p3_y, var.p2_x, var.p2_y, var.p4_x, var.p4_y)

var cur_min_dist_24 = 99999999999
var cur_check_dist_total_25 = 0
var cur_check_dist_p1_26 = 0
var cur_check_dist_p2_27 = 0




; ---- get_dist_sqr(var.cur_check_dist_p1_26, var.p2_x, var.p4_y, var.p2_x, var.p2_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p1_26 = ( (var.p2_x - var.p2_x)*(var.p2_x - var.p2_x) ) + ( (var.p4_y - var.p2_y)*(var.p4_y - var.p2_y) )
; ---- get_dist_sqr() END


; ---- get_dist_sqr(var.cur_check_dist_p2_27, var.p2_x, var.p4_y, var.p4_x, var.p4_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p2_27 = ( (var.p2_x - var.p4_x)*(var.p2_x - var.p4_x) ) + ( (var.p4_y - var.p4_y)*(var.p4_y - var.p4_y) )
; ---- get_dist_sqr() END


set var.cur_check_dist_total_25 = var.cur_check_dist_p1_26 + var.cur_check_dist_p2_27

if var.cur_min_dist_24 > var.cur_check_dist_total_25
    ; Found a closer corner
    set var.p3_x = var.p2_x
    set var.p3_y = var.p4_y
    set var.cur_min_dist_24 = var.cur_check_dist_total_25




; ---- get_dist_sqr(var.cur_check_dist_p1_26, var.p4_x, var.p2_y, var.p2_x, var.p2_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p1_26 = ( (var.p4_x - var.p2_x)*(var.p4_x - var.p2_x) ) + ( (var.p2_y - var.p2_y)*(var.p2_y - var.p2_y) )
; ---- get_dist_sqr() END


; ---- get_dist_sqr(var.cur_check_dist_p2_27, var.p4_x, var.p2_y, var.p4_x, var.p4_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p2_27 = ( (var.p4_x - var.p4_x)*(var.p4_x - var.p4_x) ) + ( (var.p2_y - var.p4_y)*(var.p2_y - var.p4_y) )
; ---- get_dist_sqr() END


set var.cur_check_dist_total_25 = var.cur_check_dist_p1_26 + var.cur_check_dist_p2_27

if var.cur_min_dist_24 > var.cur_check_dist_total_25
    ; Found a closer corner
    set var.p3_x = var.p4_x
    set var.p3_y = var.p2_y
    set var.cur_min_dist_24 = var.cur_check_dist_total_25



; ---- find_manhattan_midpoint() END







; Optimisation loop #0 (removes extra points)


; ---- optimise_extra_points(var.src_x, var.src_y, var.p1_x, var.p1_y, var.p2_x, var.p2_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.src_x == var.p1_x) && (var.p1_x == var.p2_x)) || ((var.src_y == var.p1_y) && (var.p1_y == var.p2_y))
    set var.p1_x = var.p2_x
    set var.p1_y = var.p2_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p1_x, var.p1_y, var.p2_x, var.p2_y, var.p3_x, var.p3_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p1_x == var.p2_x) && (var.p2_x == var.p3_x)) || ((var.p1_y == var.p2_y) && (var.p2_y == var.p3_y))
    set var.p2_x = var.p3_x
    set var.p2_y = var.p3_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p2_x, var.p2_y, var.p3_x, var.p3_y, var.p4_x, var.p4_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p2_x == var.p3_x) && (var.p3_x == var.p4_x)) || ((var.p2_y == var.p3_y) && (var.p3_y == var.p4_y))
    set var.p3_x = var.p4_x
    set var.p3_y = var.p4_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p3_x, var.p3_y, var.p4_x, var.p4_y, var.p5_x, var.p5_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p3_x == var.p4_x) && (var.p4_x == var.p5_x)) || ((var.p3_y == var.p4_y) && (var.p4_y == var.p5_y))
    set var.p4_x = var.p5_x
    set var.p4_y = var.p5_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p4_x, var.p4_y, var.p5_x, var.p5_y, var.dst_x, var.dst_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p4_x == var.p5_x) && (var.p5_x == var.dst_x)) || ((var.p4_y == var.p5_y) && (var.p5_y == var.dst_y))
    set var.p5_x = var.dst_x
    set var.p5_y = var.dst_y
; ---- optimise_extra_points() END



; Optimisation loop #1 (removes extra points)


; ---- optimise_extra_points(var.src_x, var.src_y, var.p1_x, var.p1_y, var.p2_x, var.p2_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.src_x == var.p1_x) && (var.p1_x == var.p2_x)) || ((var.src_y == var.p1_y) && (var.p1_y == var.p2_y))
    set var.p1_x = var.p2_x
    set var.p1_y = var.p2_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p1_x, var.p1_y, var.p2_x, var.p2_y, var.p3_x, var.p3_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p1_x == var.p2_x) && (var.p2_x == var.p3_x)) || ((var.p1_y == var.p2_y) && (var.p2_y == var.p3_y))
    set var.p2_x = var.p3_x
    set var.p2_y = var.p3_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p2_x, var.p2_y, var.p3_x, var.p3_y, var.p4_x, var.p4_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p2_x == var.p3_x) && (var.p3_x == var.p4_x)) || ((var.p2_y == var.p3_y) && (var.p3_y == var.p4_y))
    set var.p3_x = var.p4_x
    set var.p3_y = var.p4_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p3_x, var.p3_y, var.p4_x, var.p4_y, var.p5_x, var.p5_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p3_x == var.p4_x) && (var.p4_x == var.p5_x)) || ((var.p3_y == var.p4_y) && (var.p4_y == var.p5_y))
    set var.p4_x = var.p5_x
    set var.p4_y = var.p5_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p4_x, var.p4_y, var.p5_x, var.p5_y, var.dst_x, var.dst_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p4_x == var.p5_x) && (var.p5_x == var.dst_x)) || ((var.p4_y == var.p5_y) && (var.p5_y == var.dst_y))
    set var.p5_x = var.dst_x
    set var.p5_y = var.dst_y
; ---- optimise_extra_points() END



; Optimisation loop #2 (removes extra points)


; ---- optimise_extra_points(var.src_x, var.src_y, var.p1_x, var.p1_y, var.p2_x, var.p2_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.src_x == var.p1_x) && (var.p1_x == var.p2_x)) || ((var.src_y == var.p1_y) && (var.p1_y == var.p2_y))
    set var.p1_x = var.p2_x
    set var.p1_y = var.p2_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p1_x, var.p1_y, var.p2_x, var.p2_y, var.p3_x, var.p3_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p1_x == var.p2_x) && (var.p2_x == var.p3_x)) || ((var.p1_y == var.p2_y) && (var.p2_y == var.p3_y))
    set var.p2_x = var.p3_x
    set var.p2_y = var.p3_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p2_x, var.p2_y, var.p3_x, var.p3_y, var.p4_x, var.p4_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p2_x == var.p3_x) && (var.p3_x == var.p4_x)) || ((var.p2_y == var.p3_y) && (var.p3_y == var.p4_y))
    set var.p3_x = var.p4_x
    set var.p3_y = var.p4_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p3_x, var.p3_y, var.p4_x, var.p4_y, var.p5_x, var.p5_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p3_x == var.p4_x) && (var.p4_x == var.p5_x)) || ((var.p3_y == var.p4_y) && (var.p4_y == var.p5_y))
    set var.p4_x = var.p5_x
    set var.p4_y = var.p5_y
; ---- optimise_extra_points() END



; ---- optimise_extra_points(var.p4_x, var.p4_y, var.p5_x, var.p5_y, var.dst_x, var.dst_y)
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if ((var.p4_x == var.p5_x) && (var.p5_x == var.dst_x)) || ((var.p4_y == var.p5_y) && (var.p5_y == var.dst_y))
    set var.p5_x = var.dst_x
    set var.p5_y = var.dst_y
; ---- optimise_extra_points() END




var prev_mov_x = var.src_x
var prev_mov_y = var.src_y


if (var.src_x != var.prev_mov_x) || (var.src_y != var.prev_mov_y)
    G1 X{ var.src_x } Y{ var.src_y } F{ param.F }
    set var.prev_mov_x = var.src_x
    set var.prev_mov_y = var.src_y

if (var.p1_x != var.prev_mov_x) || (var.p1_y != var.prev_mov_y)
    G1 X{ var.p1_x } Y{ var.p1_y } F{ param.F }
    set var.prev_mov_x = var.p1_x
    set var.prev_mov_y = var.p1_y

if (var.p2_x != var.prev_mov_x) || (var.p2_y != var.prev_mov_y)
    G1 X{ var.p2_x } Y{ var.p2_y } F{ param.F }
    set var.prev_mov_x = var.p2_x
    set var.prev_mov_y = var.p2_y

if (var.p3_x != var.prev_mov_x) || (var.p3_y != var.prev_mov_y)
    G1 X{ var.p3_x } Y{ var.p3_y } F{ param.F }
    set var.prev_mov_x = var.p3_x
    set var.prev_mov_y = var.p3_y

if (var.p4_x != var.prev_mov_x) || (var.p4_y != var.prev_mov_y)
    G1 X{ var.p4_x } Y{ var.p4_y } F{ param.F }
    set var.prev_mov_x = var.p4_x
    set var.prev_mov_y = var.p4_y

if (var.p5_x != var.prev_mov_x) || (var.p5_y != var.prev_mov_y)
    G1 X{ var.p5_x } Y{ var.p5_y } F{ param.F }
    set var.prev_mov_x = var.p5_x
    set var.prev_mov_y = var.p5_y

if (var.dst_x != var.prev_mov_x) || (var.dst_y != var.prev_mov_y)
    G1 X{ var.dst_x } Y{ var.dst_y } F{ param.F }
    set var.prev_mov_x = var.dst_x
    set var.prev_mov_y = var.dst_y


; ---- manhattan_move() END

G91
G0 Z{-param.Z}
G90

; (TEST ONLY)
;G0 X{var.src_x} Y{var.src_y}
