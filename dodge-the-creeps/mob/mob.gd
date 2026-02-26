extends RigidBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var possible_anims = Array(animated_sprite_2d.sprite_frames.get_animation_names())
	animated_sprite_2d.play(possible_anims.pick_random())

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
