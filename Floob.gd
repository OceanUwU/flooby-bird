extends Area2D

signal hit
signal first_flap

const GRAVITY = 28
const FLAP_POWER = 12

const ALL_UP_VELOCITY = 2
const ALL_UP_ROTATION = -0.25 * PI
const ALL_DOWN_VELOCITY = -5
const ALL_DOWN_ROTATION = 0.6 * PI
const ROTATION_SPEED = 5
var velocity = 0
var original_y

const WING_MAX_ROTATION = 0.1 * PI
const WING_ROTATION_SPEED = 0.4
var wings
var wing_flap_direction = 1

const MIN_HEIGHT = 1120

var alive = false
var flapped_yet = false

func _ready():
    wings = [$LeftWing, $RightWing]
    original_y = self.position.y
    
func start():
    velocity = 0
    self.position.y = original_y
    $CollisionShape2D.disabled = false
    alive = true
    flapped_yet = false

func _input(event):
    if alive && self.position.y > 0 && ((event is InputEventMouseButton && event.button_index == 1 && event.is_pressed()) || (event is InputEventScreenTouch && event.pressed)):
        velocity = -FLAP_POWER
        if (!flapped_yet):
            flapped_yet = true
            emit_signal('first_flap')

func _process(_delta):
    #rotate floob
    if (self.position.y < MIN_HEIGHT):
        var target_rotation = ALL_UP_ROTATION + ((clamp(velocity, ALL_DOWN_VELOCITY, ALL_UP_VELOCITY) - ALL_DOWN_VELOCITY) / (ALL_UP_VELOCITY - ALL_DOWN_VELOCITY) * (ALL_DOWN_ROTATION - ALL_UP_ROTATION))
        self.rotation += (target_rotation - self.rotation) * _delta * ROTATION_SPEED
    
    #rotate wings
    if (abs(wings[0].rotation) > WING_MAX_ROTATION * 0.98):
        wing_flap_direction *= -1
    var wing_rotation = clamp(wings[0].rotation + (wing_flap_direction * WING_ROTATION_SPEED * (clamp(velocity, -FLAP_POWER, 0) / -FLAP_POWER)), -WING_MAX_ROTATION, WING_MAX_ROTATION)
    for i in range(2):
        wings[i].rotation = wing_rotation * (i*2-1)*-1
    
func _physics_process(delta):
    if (flapped_yet):
        velocity += delta * GRAVITY
    else:
        velocity = sin(float(OS.get_ticks_msec()) / 300) * 1.7
    self.position.y += velocity
    self.position.y = clamp(self.position.y, -INF, MIN_HEIGHT)
    if (alive && self.position.y == MIN_HEIGHT):
        die()

func _on_Floob_area_shape_entered(_area_id, _area, _area_shape, _local_shape):
    die()
    
func die():
    emit_signal('hit')
    $CollisionShape2D.set_deferred('disabled', true)
    alive = false
