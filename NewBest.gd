extends TextureRect


const OSCILLATE_STRENGTH = 0.6 #how far out the arrow goes

func _process(delta):
    self.rect_position.x -= sin(float(OS.get_ticks_msec()) / 300) * OSCILLATE_STRENGTH
