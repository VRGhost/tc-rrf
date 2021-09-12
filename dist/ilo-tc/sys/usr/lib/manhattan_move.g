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








var src_x = move.axes[0].userPosition
var src_y = move.axes[1].userPosition

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




; ---- find_nearest_manhattan_point(var.p1_x, var.p1_y, var.src_x, var.src_y, 0, 0, 285, 185)

var dx_6 = 0
var dy_7 = 0

; Step 1 - move to the nearest edge
; --- Find the minimum dx/dy to move to the rectangle

; ----- Find min dx (by abs)
set var.dx_6 = 0 - var.src_x
if abs(var.dx_6) > abs(285 - var.src_x)
    set var.dx_6 = 285 - var.src_x

; ------ Find min dy (by abs)
set var.dy_7 = 0 - var.src_y
if abs(var.dy_7) > abs(185 - var.src_y)
    set var.dy_7 = 185 - var.src_y

; --- Pick the side with minimum delta
if abs(var.dx_6) > abs(var.dy_7)
    set var.dx_6 = 0
else
    set var.dy_7 = 0

set var.p1_x = var.src_x + var.dx_6
set var.p1_y = var.src_y + var.dy_7

; ---- find_nearest_manhattan_point() END

; ---- find_nearest_manhattan_point(var.p5_x, var.p5_y, var.dst_x, var.dst_y, 0, 0, 285, 185)

var dx_8 = 0
var dy_9 = 0

; Step 1 - move to the nearest edge
; --- Find the minimum dx/dy to move to the rectangle

; ----- Find min dx (by abs)
set var.dx_8 = 0 - var.dst_x
if abs(var.dx_8) > abs(285 - var.dst_x)
    set var.dx_8 = 285 - var.dst_x

; ------ Find min dy (by abs)
set var.dy_9 = 0 - var.dst_y
if abs(var.dy_9) > abs(185 - var.dst_y)
    set var.dy_9 = 185 - var.dst_y

; --- Pick the side with minimum delta
if abs(var.dx_8) > abs(var.dy_9)
    set var.dx_8 = 0
else
    set var.dy_9 = 0

set var.p5_x = var.dst_x + var.dx_8
set var.p5_y = var.dst_y + var.dy_9

; ---- find_nearest_manhattan_point() END


; ---- find_nearest_manhattan_corner(var.p2_x, var.p2_y, var.p1_x, var.p1_y, 0, 0, 285, 185)

var cur_min_dist_10 = 99999999999
var cur_check_dist_11 = 0

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_11, 0, 0, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_11 = ( (0 - var.p1_x)*(0 - var.p1_x) ) + ( (0 - var.p1_y)*(0 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_10 > var.cur_check_dist_11 && ( 0 == var.p1_x || 0 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 0
    set var.p2_y = 0
    set var.cur_min_dist_10 = var.cur_check_dist_11
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_11, 0, 185, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_11 = ( (0 - var.p1_x)*(0 - var.p1_x) ) + ( (185 - var.p1_y)*(185 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_10 > var.cur_check_dist_11 && ( 0 == var.p1_x || 185 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 0
    set var.p2_y = 185
    set var.cur_min_dist_10 = var.cur_check_dist_11

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_11, 285, 0, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_11 = ( (285 - var.p1_x)*(285 - var.p1_x) ) + ( (0 - var.p1_y)*(0 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_10 > var.cur_check_dist_11 && ( 285 == var.p1_x || 0 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 285
    set var.p2_y = 0
    set var.cur_min_dist_10 = var.cur_check_dist_11
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_11, 285, 185, var.p1_x, var.p1_y)
;  Return square of distance between coordinates
set var.cur_check_dist_11 = ( (285 - var.p1_x)*(285 - var.p1_x) ) + ( (185 - var.p1_y)*(185 - var.p1_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_10 > var.cur_check_dist_11 && ( 285 == var.p1_x || 185 == var.p1_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p2_x = 285
    set var.p2_y = 185
    set var.cur_min_dist_10 = var.cur_check_dist_11



; ---- find_nearest_manhattan_corner() END

; ---- find_nearest_manhattan_corner(var.p4_x, var.p4_y, var.p5_x, var.p5_y, 0, 0, 285, 185)

var cur_min_dist_12 = 99999999999
var cur_check_dist_13 = 0

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_13, 0, 0, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_13 = ( (0 - var.p5_x)*(0 - var.p5_x) ) + ( (0 - var.p5_y)*(0 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_12 > var.cur_check_dist_13 && ( 0 == var.p5_x || 0 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 0
    set var.p4_y = 0
    set var.cur_min_dist_12 = var.cur_check_dist_13
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_13, 0, 185, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_13 = ( (0 - var.p5_x)*(0 - var.p5_x) ) + ( (185 - var.p5_y)*(185 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_12 > var.cur_check_dist_13 && ( 0 == var.p5_x || 185 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 0
    set var.p4_y = 185
    set var.cur_min_dist_12 = var.cur_check_dist_13

 ; x loop
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_13, 285, 0, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_13 = ( (285 - var.p5_x)*(285 - var.p5_x) ) + ( (0 - var.p5_y)*(0 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_12 > var.cur_check_dist_13 && ( 285 == var.p5_x || 0 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 285
    set var.p4_y = 0
    set var.cur_min_dist_12 = var.cur_check_dist_13
 ; y loop

; ---- get_dist_sqr(var.cur_check_dist_13, 285, 185, var.p5_x, var.p5_y)
;  Return square of distance between coordinates
set var.cur_check_dist_13 = ( (285 - var.p5_x)*(285 - var.p5_x) ) + ( (185 - var.p5_y)*(185 - var.p5_y) )
; ---- get_dist_sqr() END

if var.cur_min_dist_12 > var.cur_check_dist_13 && ( 285 == var.p5_x || 185 == var.p5_y) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set var.p4_x = 285
    set var.p4_y = 185
    set var.cur_min_dist_12 = var.cur_check_dist_13



; ---- find_nearest_manhattan_corner() END



; ---- find_manhattan_midpoint(var.p3_x, var.p3_y, var.p2_x, var.p2_y, var.p4_x, var.p4_y)

var cur_min_dist_14 = 99999999999
var cur_check_dist_total_15 = 0
var cur_check_dist_p1_16 = 0
var cur_check_dist_p2_17 = 0




; ---- get_dist_sqr(var.cur_check_dist_p1_16, var.p2_x, var.p4_y, var.p2_x, var.p2_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p1_16 = ( (var.p2_x - var.p2_x)*(var.p2_x - var.p2_x) ) + ( (var.p4_y - var.p2_y)*(var.p4_y - var.p2_y) )
; ---- get_dist_sqr() END


; ---- get_dist_sqr(var.cur_check_dist_p2_17, var.p2_x, var.p4_y, var.p4_x, var.p4_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p2_17 = ( (var.p2_x - var.p4_x)*(var.p2_x - var.p4_x) ) + ( (var.p4_y - var.p4_y)*(var.p4_y - var.p4_y) )
; ---- get_dist_sqr() END


set var.cur_check_dist_total_15 = var.cur_check_dist_p1_16 + var.cur_check_dist_p2_17

if var.cur_min_dist_14 > var.cur_check_dist_total_15
    ; Found a closer corner
    set var.p3_x = var.p2_x
    set var.p3_y = var.p4_y
    set var.cur_min_dist_14 = var.cur_check_dist_total_15




; ---- get_dist_sqr(var.cur_check_dist_p1_16, var.p4_x, var.p2_y, var.p2_x, var.p2_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p1_16 = ( (var.p4_x - var.p2_x)*(var.p4_x - var.p2_x) ) + ( (var.p2_y - var.p2_y)*(var.p2_y - var.p2_y) )
; ---- get_dist_sqr() END


; ---- get_dist_sqr(var.cur_check_dist_p2_17, var.p4_x, var.p2_y, var.p4_x, var.p4_y)
;  Return square of distance between coordinates
set var.cur_check_dist_p2_17 = ( (var.p4_x - var.p4_x)*(var.p4_x - var.p4_x) ) + ( (var.p2_y - var.p4_y)*(var.p2_y - var.p4_y) )
; ---- get_dist_sqr() END


set var.cur_check_dist_total_15 = var.cur_check_dist_p1_16 + var.cur_check_dist_p2_17

if var.cur_min_dist_14 > var.cur_check_dist_total_15
    ; Found a closer corner
    set var.p3_x = var.p4_x
    set var.p3_y = var.p2_y
    set var.cur_min_dist_14 = var.cur_check_dist_total_15



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
