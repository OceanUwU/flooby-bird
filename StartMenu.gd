extends CanvasLayer

signal start

func _on_Button_pressed():
    $Button.disabled = true
    emit_signal('start')
