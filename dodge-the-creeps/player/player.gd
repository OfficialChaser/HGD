extends CharacterBody2D
class_name Player

# Signals
signal hit

# References
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Player stats
var direction : Vector2
@export var speed : float
@export var acc : float
@export var dec : float

var past_global_pos : Vector2
var stationary : bool

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = lerp(velocity, direction * speed, acc * delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, dec * delta)
	
	past_global_pos = global_position
	move_and_slide()
	
func _process(_delta):
	_handle_animations()
	if direction:
		_handle_flipping()

func _handle_animations():
	if abs(round(velocity.x)) > abs(round(velocity.y)):
		animated_sprite_2d.animation = "walk"
	elif abs(round(velocity.x)) < abs(round(velocity.y)):
		animated_sprite_2d.animation = "up"
	else:
		animated_sprite_2d.animation = "idle"

func _handle_flipping():
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	if direction.y < 0:
		animated_sprite_2d.flip_v = false
	elif direction.y > 0:
		animated_sprite_2d.flip_v = true

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("mob"):
		hit.emit()
		queue_free()
