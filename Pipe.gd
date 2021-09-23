extends Area2D

signal score

const FAR_DISTANCE = 1000.0
const FAR_SPEED = 1200.0

var scored = false
var floob

func _ready():
    floob = get_node('../Floob')

func _physics_process(delta):
    if (floob.alive):
        self.position.x -= ((Globals.SCROLL_SPEED + FAR_SPEED * ((self.position.x - FAR_DISTANCE) / FAR_DISTANCE)) if self.position.x > FAR_DISTANCE else Globals.SCROLL_SPEED) * delta
        if (self.position.x < -500):
            queue_free()
        if (!scored && self.position.x < floob.position.x):
            scored = true
            emit_signal('score')
