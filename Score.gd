extends Label

var score
var time
var time_passed
var done = true

func count(new_score, new_time):
    score = new_score
    time = new_time
    time_passed = 0.0
    done = false

func _process(delta):
    #rolling number counter here lol
    if (!done):
        time_passed += delta
        var score_shown = int(round(score * (1 - pow(1 - (time_passed / time), 3)))) #cubic ease out function
        self.text = str(score_shown)
        if (score_shown >= score):
            done = true
