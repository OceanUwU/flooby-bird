extends Area2D

var texture_width
var floob

func _ready():
    texture_width = $TextureRect.texture.get_width() * $TextureRect.rect_scale.x
    floob = get_node('../Floob')

func _process(delta):
    if (floob.alive):
        self.position.x -= Globals.SCROLL_SPEED * delta
        if self.position.x < -texture_width:
            self.position.x += texture_width
