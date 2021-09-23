extends Node

var texture_width
var floob

func _ready():
    texture_width = $TextureRect.texture.get_width() * $TextureRect.rect_scale.x
    floob = get_node('../Floob')

func _process(delta):
    if (floob.alive):
        self.offset.x -= Globals.SCROLL_SPEED * 0.3 * delta
        if self.offset.x < -texture_width:
            self.offset.x += texture_width
