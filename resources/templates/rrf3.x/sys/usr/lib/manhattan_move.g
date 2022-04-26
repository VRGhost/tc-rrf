; Manhattan move - move to X, Y but while moving around the bed

{% import '__macros__/move.jinja' as move %}

; ##### find_nearest_manhattan_point
;       Finds the point on the (min x, min y), (max x, max y) rectangle
;       that is nearest to the (target x, target y)
{% macro find_nearest_manhattan_point(
    out_x_var, out_y_var,
    cur_x, cur_y,
    min_x, min_y,
    max_x, max_y
) -%}
; ---- find_nearest_manhattan_point({{out_x_var}}, {{out_y_var}}, {{cur_x}}, {{cur_y}}, {{min_x}}, {{min_y}}, {{max_x}}, {{max_y}})

{% set dx = py.unique_var('dx') -%}
{% set dy = py.unique_var('dy') -%}

var {{ dx }} = 0
var {{ dy }} = 0

; Step 1 - move to the nearest edge
; --- Find the minimum dx/dy to move to the rectangle

; ----- Find min dx (by abs)
set var.{{ dx }} = {{ min_x }} - {{ cur_x }}
if abs(var.{{ dx }}) > abs({{ max_x }} - {{ cur_x }})
    set var.{{ dx }} = {{ max_x }} - {{ cur_x }}

; ------ Find min dy (by abs)
set var.{{ dy }} = {{ min_y }} - {{ cur_y }}
if abs(var.{{ dy }}) > abs({{ max_y }} - {{ cur_y }})
    set var.{{ dy }} = {{ max_y }} - {{ cur_y }}

; --- Pick the side with minimum delta
if abs(var.{{ dx }}) > abs(var.{{ dy }})
    set var.{{ dx }} = 0
else
    set var.{{ dy }} = 0

set {{ out_x_var }} = {{ cur_x }} + var.{{ dx }}
set {{ out_y_var }} = {{ cur_y }} + var.{{ dy }}

; ---- find_nearest_manhattan_point() END
{% endmacro -%}

{% macro get_dist_sqr(out_var, x1, y1, x2, y2) %}
; ---- get_dist_sqr({{out_var}}, {{x1}}, {{y1}}, {{x2}}, {{y2}})
;  Return square of distance between coordinates
set {{out_var}} = ( ({{x1}} - {{x2}})*({{x1}} - {{x2}}) ) + ( ({{y1}} - {{y2}})*({{y1}} - {{y2}}) )
; ---- get_dist_sqr() END
{% endmacro %}

{% macro find_nearest_manhattan_corner(
    out_x_var, out_y_var,
    cur_x, cur_y,
    min_x, min_y,
    max_x, max_y
) -%}
; ---- find_nearest_manhattan_corner({{out_x_var}}, {{out_y_var}}, {{cur_x}}, {{cur_y}}, {{min_x}}, {{min_y}}, {{max_x}}, {{max_y}})

{% set cur_min_dist = py.unique_var('cur_min_dist') -%}
{% set cur_check_dist = py.unique_var('cur_check_dist') -%}

var {{ cur_min_dist }} = 99999999999
var {{ cur_check_dist }} = 0

{% for check_x in [min_x, max_x] %} ; x loop
{% for check_y in [min_y, max_y] %} ; y loop
{{ get_dist_sqr('var.' + cur_check_dist, check_x, check_y, cur_x, cur_y) }}
if var.{{cur_min_dist}} > var.{{ cur_check_dist }} && ( {{ check_x }} == {{ cur_x }} || {{ check_y }} == {{ cur_y }}) ; (only check pairs that are on the same axis)
    ; Found a closer corner
    set {{ out_x_var }} = {{ check_x }}
    set {{ out_y_var }} = {{ check_y }}
    set var.{{ cur_min_dist }} = var.{{ cur_check_dist }}
{% endfor %}
{% endfor %}

; ---- find_nearest_manhattan_corner() END
{% endmacro -%}

{% macro find_manhattan_midpoint(out_x_var, out_y_var, p1_x, p1_y, p2_x, p2_y) %}
; ---- find_manhattan_midpoint({{out_x_var}}, {{out_y_var}}, {{p1_x}}, {{p1_y}}, {{p2_x}}, {{p2_y}})

{% set cur_min_dist = py.unique_var('cur_min_dist') -%}
{% set cur_check_dist_total = py.unique_var('cur_check_dist_total') -%}
{% set cur_check_dist_p1 = py.unique_var('cur_check_dist_p1') -%}
{% set cur_check_dist_p2 = py.unique_var('cur_check_dist_p2') -%}

var {{ cur_min_dist }} = 99999999999
var {{ cur_check_dist_total }} = 0
var {{ cur_check_dist_p1 }} = 0
var {{ cur_check_dist_p2 }} = 0

{% for (check_x, check_y) in [(p1_x, p2_y), (p2_x, p1_y)] %}

{{ get_dist_sqr('var.' + cur_check_dist_p1, check_x, check_y, p1_x, p1_y) }}
{{ get_dist_sqr('var.' + cur_check_dist_p2, check_x, check_y, p2_x, p2_y) }}

set var.{{ cur_check_dist_total }} = var.{{ cur_check_dist_p1 }} + var.{{ cur_check_dist_p2 }}

if var.{{cur_min_dist}} > var.{{ cur_check_dist_total }}
    ; Found a closer corner
    set {{ out_x_var }} = {{ check_x }}
    set {{ out_y_var }} = {{ check_y }}
    set var.{{ cur_min_dist }} = var.{{ cur_check_dist_total }}

{% endfor %}

; ---- find_manhattan_midpoint() END
{% endmacro %}


{% macro optimise_extra_points(p1_x, p1_y, p2_x, p2_y, p3_x, p3_y ) %}
; ---- optimise_extra_points({{p1_x}}, {{p1_y}}, {{p2_x}}, {{p2_y}}, {{p3_x}}, {{p3_y}})
; Removes P2 (x, y) coords IF all of p1, p2 and p3 are laying on a same line
if (({{ p1_x }} == {{ p2_x }}) && ({{ p2_x }} == {{ p3_x }})) || (({{ p1_y }} == {{ p2_y }}) && ({{ p2_y }} == {{ p3_y }}))
    set {{ p2_x }} = {{ p3_x }}
    set {{ p2_y }} = {{ p3_y }}
; ---- optimise_extra_points() END
{% endmacro %}

; Params:
;   X, Y - target coords
;   Z - delta Z to raise/lower the bed by
;   F - move speed




{% call move.rel_move() %}
G0 Z{param.Z}
{% endcall %}

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



{% set min_x = 0 %}
{% set min_y = 0 %}
{% set max_x = bed.width - 15 %}
{% set max_y = bed.depth - 15 %}

var src_x = move.axes[{{ axis.X.index }}].userPosition
var src_y = move.axes[{{ axis.Y.index }}].userPosition

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




{{ find_nearest_manhattan_point('var.p1_x', 'var.p1_y', 'var.src_x', 'var.src_y', min_x, min_y, max_x, max_y) }}
{{ find_nearest_manhattan_point('var.p5_x', 'var.p5_y', 'var.dst_x', 'var.dst_y', min_x, min_y, max_x, max_y) }}

{{ find_nearest_manhattan_corner('var.p2_x', 'var.p2_y', 'var.p1_x', 'var.p1_y', min_x, min_y, max_x, max_y) }}
{{ find_nearest_manhattan_corner('var.p4_x', 'var.p4_y', 'var.p5_x', 'var.p5_y', min_x, min_y, max_x, max_y) }}

{{ find_manhattan_midpoint('var.p3_x', 'var.p3_y', 'var.p2_x', 'var.p2_y', 'var.p4_x', 'var.p4_y') }}

{% set head_point = ('var.src_x', 'var.src_y') %}
{% set all_midpoints = (
    ('var.p1_x', 'var.p1_y'),
    ('var.p2_x', 'var.p2_y'),
    ('var.p3_x', 'var.p3_y'),
    ('var.p4_x', 'var.p4_y'),
    ('var.p5_x', 'var.p5_y'),
)
%}
{% set end_point = ('var.dst_x', 'var.dst_y') %}

{% for repeat in range(3) %}
; Optimisation loop #{{repeat}} (removes extra points)
{% for (p1, p2, p3) in py.zip(
    (head_point, ) + all_midpoints,
    all_midpoints,
    all_midpoints[1:] + (end_point, ),
) %}
{{ optimise_extra_points(p1[0], p1[1], p2[0], p2[1], p3[0], p3[1])}}
{% endfor %}
{% endfor %}

var prev_mov_x = var.src_x
var prev_mov_y = var.src_y

{% for (dst_x, dst_y) in (head_point, ) + all_midpoints + (end_point, ) %}
if ({{ dst_x }} != var.prev_mov_x) || ({{ dst_y }} != var.prev_mov_y)
    G1 X{ {{dst_x}} } Y{ {{dst_y}} } F{ param.F }
    set var.prev_mov_x = {{ dst_x }}
    set var.prev_mov_y = {{ dst_y }}
{% endfor %}

; ---- manhattan_move() END

{% call move.rel_move() %}
G0 Z{-param.Z}
{% endcall %}

; (TEST ONLY)
;G0 X{var.src_x} Y{var.src_y}