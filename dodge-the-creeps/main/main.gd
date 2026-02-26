extends Node2D

# References
@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
@onready var gui: Control = $CanvasLayer/GUI

# Game Stats
var score := 0
var can_restart := false
var game_started := false

func _ready():
	gui.connect("enable_restart", _on_restart_enabled)

func _input(event: InputEvent):
	if event.is_action_pressed("restart") and can_restart:
		get_tree().reload_current_scene()
	if event.is_action_pressed("space") and !game_started:
		game_started = true
		gui.start_timers()

func _on_gui_spawn_mob():
	score += 1
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_player_hit():
	score = 0
	gui.stop_timers()

func _on_restart_enabled():
	can_restart = true

func _on_gui_spawn_coin() -> void:
	var coin = coin_scene.instantiate()
	add_child(coin)
	
	var screen_size = get_viewport().get_visible_rect().size
	
	var margin = 32
	
	var random_x = randf_range(margin, screen_size.x - margin)
	var random_y = randf_range(margin, screen_size.y - margin)
	
	coin.position = Vector2(random_x, random_y)
	
	coin.collected.connect(_on_coin_collected)


func _on_coin_collected():
	gui.boost_score()
