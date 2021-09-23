extends Node

const FLASH_TIME = 0.3
const TRANSITION_TIME = 0.6

export (PackedScene) var Pipe
var score

func _ready():
    $Floob.hide()
    $HUD.scale.x = 0
    $DeathMenu.scale.x = 0
    randomize()
    
func start_game():
    $StartMenu.layer = 1
    $DeathMenu.layer = 1
    $Transition/Tween.interpolate_property($Transition/Black, 'modulate', Color(0,0,0,0), Color(0,0,0,1), TRANSITION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Transition/Tween.start()
    yield($Transition/Tween, 'tween_completed')
    
    get_tree().call_group('pipes', 'queue_free')
    $Floob.show()
    $Floob.start()
    score = 0
    $HUD/Score.text = str(score)
    $StartMenu.scale.x = 0
    $HUD.scale.x = 1
    $DeathMenu.reset()
    
    $Transition/Tween.interpolate_property($Transition/Black, 'modulate', Color(0,0,0,1), Color(0,0,0,0), TRANSITION_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Transition/Tween.start()
    
func start_pipes():
    $PipeTimer.start()
    _on_PipeTimer_timeout()

func _on_PipeTimer_timeout():
    var pipe = Pipe.instance()
    add_child(pipe)
    $PipePath/PipeSpawnLocation.offset = randi()
    pipe.position = $PipePath/PipeSpawnLocation.position
    pipe.connect('score', self, '_on_Pipe_score')

func game_over():
    $HUD.scale.x = 0
    $Flash/Tween.interpolate_property($Flash/White, 'modulate', Color(1,1,1,1), Color(1,1,1,0), FLASH_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $Flash/Tween.start()
    $PipeTimer.stop()
    $DeathMenu.layer = 101
    $DeathMenu.death(score)

func _on_Floob_hit():
    game_over()

func _on_Pipe_score():
    score += 1
    $HUD/Score.text = str(score)


func _on_Floob_first_flap():
    if ($HUD/TapGuide.modulate.a > 0):
        $HUD/TapGuide/Tween.interpolate_property($HUD/TapGuide, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
        $HUD/TapGuide/Tween.start()
    start_pipes()


func _on_StartMenu_start():
    start_game()


func _on_DeathMenu_start():
    start_game()
