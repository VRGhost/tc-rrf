; Test a particular tool

{% import '__macros__/errors.jinja' as errors %}

G1 Z50

var iter_count = exists(param.I) ? param.I : 3

echo "Testing Tool #" ^ param.T ^ " (" ^ var.iter_count ^ " iterations)"

var counter = 0
var counter2 = 0
while var.counter < var.iter_count
    set var.counter = var.counter + 1
    T{param.T}
    {{ errors.abort_on_error("Error picking up tool", indent=4) }}
    set var.counter2 = 0
    while var.counter2 < var.iter_count
        set var.counter2 = var.counter2 + 1
        G1 X{{bed.X.min + 20}} Y{{bed.Y.min + 20}} F50000
        {{ errors.abort_on_error("Error in mov 1", indent=8) }}
        G1 X{{bed.X.max - 50}} Y{{bed.Y.min + 20}} F50000
        {{ errors.abort_on_error("Error in mov 2", indent=8) }}
        G1 X{{bed.X.max - 50}} Y{{bed.Y.max - 50}} F50000
        {{ errors.abort_on_error("Error in mov 3", indent=8) }}
        G1 X{{bed.X.min + 20}} Y{{bed.Y.max - 50}} F50000
        {{ errors.abort_on_error("Error in mov 4", indent=8) }}
    T-1
    {{ errors.abort_on_error("Error releasing the tool", indent=4) }}