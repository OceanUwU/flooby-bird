extends CanvasLayer

signal start

const JUMP_TIME = 0.4
const JUMP_HEIGHT = 50
const BOX_SLIDE_TIME = 0.5
const BUTTON_SHOW_TIME = 0.3
const SCORE_COUNT_TIME = 0.8
const NEW_BEST_SHOW_TIME = 0.6
const MEDAL_SHOW_TIME = 0.7

var game_over_original_y
var info_box_original_y
var medal_original_scale
var medals
var best

func _ready():
    game_over_original_y = $GameOver.rect_position.y
    info_box_original_y = $InfoBox.rect_position.y
    medal_original_scale = $InfoBox/Medal.scale
    medals = $InfoBox/Medal.frames.get_animation_names()
    
    var best_file = File.new()
    best_file.open('user://best.dat', File.READ)
    best = int(best_file.get_as_text())
    $InfoBox/Best.text = str(best)

func reset():
    self.scale.x = 0
    $GameOver.modulate.a = 0
    $Button.modulate.a = 0
    $InfoBox.rect_position.y = 10000
    $Button.disabled = true
    $InfoBox/Score.text = '0'
    $InfoBox/BestLabel/New.modulate.a = 0
    $InfoBox/Medal.hide()
    $InfoBox/Medal.stop()
    $InfoBox/Medal.frame = 0

func death(score):
    self.scale.x = 1
    
    #show "game over"
    $GameOver/Opacity.interpolate_property($GameOver, 'modulate', Color(1,1,1,0), Color(1,1,1,1), JUMP_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    $GameOver/Opacity.start()
    $GameOver/Position.interpolate_property($GameOver, 'rect_position:y', game_over_original_y, game_over_original_y-JUMP_HEIGHT, JUMP_TIME/2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
    $GameOver/Position.start()
    yield($GameOver/Position, 'tween_completed')
    $GameOver/Position.interpolate_property($GameOver, 'rect_position:y', game_over_original_y-JUMP_HEIGHT, game_over_original_y, JUMP_TIME/2, Tween.TRANS_CUBIC, Tween.EASE_IN)
    $GameOver/Position.start()
    yield($GameOver/Position, 'tween_completed')
    
    #show infobox
    $InfoBox/Tween.interpolate_property($InfoBox, 'rect_position:y', info_box_original_y+1000, info_box_original_y, BOX_SLIDE_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    $InfoBox/Tween.start()
    yield($InfoBox/Tween, 'tween_completed')
    
    #show score
    $InfoBox/Score.count(score, MEDAL_SHOW_TIME)
    yield(get_tree().create_timer(MEDAL_SHOW_TIME), 'timeout')
    
    if (score > best): #if new best
        #update best
        best = score
        $InfoBox/Best.text = str(best)
        $InfoBox/BestLabel/New/Tween.interpolate_property($InfoBox/BestLabel/New, 'modulate', Color(1,1,1,0), Color(1,1,1,1), NEW_BEST_SHOW_TIME, Tween.TRANS_LINEAR, Tween.EASE_OUT)
        $InfoBox/BestLabel/New/Tween.start()
        yield($InfoBox/BestLabel/New/Tween, 'tween_completed')
        #save new best
        var best_file = File.new()
        best_file.open('user://best.dat', File.WRITE)
        best_file.store_string(str(best))
    
    #show medal (if they got one)
    var medal = false
    for x in medals:
        if (score >= int(x) && int(x) > int(medal)):
            medal = x
    if (medal):
        $InfoBox/Medal.animation = medal
        $InfoBox/Medal.modulate.a = 0
        $InfoBox/Medal/Opacity.interpolate_property($InfoBox/Medal, 'modulate', Color(1,1,1,0), Color(1,1,1,1), MEDAL_SHOW_TIME/2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
        $InfoBox/Medal/Opacity.start()
        $InfoBox/Medal.show()
        $InfoBox/Medal/Scale.interpolate_property($InfoBox/Medal, 'scale', medal_original_scale * 0.5, medal_original_scale * 1.5, MEDAL_SHOW_TIME/2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
        $InfoBox/Medal/Scale.start()
        yield($InfoBox/Medal/Scale, 'tween_completed')
        $InfoBox/Medal/Scale.interpolate_property($InfoBox/Medal, 'scale', $InfoBox/Medal.scale, medal_original_scale * 1, MEDAL_SHOW_TIME/2, Tween.TRANS_CUBIC, Tween.EASE_IN)
        $InfoBox/Medal/Scale.start()
        yield($InfoBox/Medal/Scale, 'tween_completed')
        $InfoBox/Medal.play()
    
    #show "again" button
    $Button/Tween.interpolate_property($Button, 'modulate', Color(1,1,1,0), Color(1,1,1,1), BUTTON_SHOW_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    $Button/Tween.start()
    $Button.disabled = false

func _on_Button_pressed():
    $Button.disabled = true
    emit_signal('start')
