; Test a particular tool



G1 Z50

var iter_count = exists(param.I) ? param.I : 3

echo "Testing Tool #" ^ param.T ^ " (" ^ var.iter_count ^ " iterations)"

var counter = 0
var counter2 = 0
while var.counter < var.iter_count
    set var.counter = var.counter + 1
    T{param.T}
    if result != 0
        abort "[ERROR]: Error picking up tool"

    set var.counter2 = 0
    while var.counter2 < var.iter_count
        set var.counter2 = var.counter2 + 1
        G1 X24 Y20 F50000
        if result != 0
            abort "[ERROR]: Error in mov 1"

        G1 X285 Y20 F50000
        if result != 0
            abort "[ERROR]: Error in mov 2"

        G1 X285 Y150 F50000
        if result != 0
            abort "[ERROR]: Error in mov 3"

        G1 X24 Y150 F50000
        if result != 0
            abort "[ERROR]: Error in mov 4"

    T-1
    if result != 0
        abort "[ERROR]: Error releasing the tool"
