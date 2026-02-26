extends Control

# Signals
signal spawn_mob
signal spawn_coin
signal enable_restart

# References
@onready var timer_label: Label = $TimerLabel
@onready var mob_timer: Timer = $MobTimer
@onready var game_timer: Timer = $GameTimer
@onready var coin_timer: Timer = $CoinTimer

@onready var score_animator: AnimationPlayer = $TimerLabel/AnimationPlayer

@onready var game_start_display: Control = $GameStartDisplay

@onready var game_over_display: Control = $GameOverDisplay
@onready var game_over_animator: AnimationPlayer = $GameOverDisplay/AnimationPlayer
@onready var score_label: Label = $GameOverDisplay/ScoreLabel


func _ready():
	game_over_display.hide()
	timer_label.hide()

func start_timers():
	timer_label.show()
	game_timer.start()
	mob_timer.start()
	coin_timer.start()
	game_start_display.hide()
	

func stop_timers():
	game_timer.stop()
	mob_timer.stop()
	coin_timer.stop()
	game_over()

func game_over():
	$GameOverSFX.play()
	score_animator.play("fade_out")
	game_over_display.show()
	game_over_animator.play("pop_in")
	enable_restart.emit()

func boost_score():
	var int_text = int(timer_label.text)
	int_text += 5
	$BlipSFX.pitch_scale = randf_range(0.8, 1.2)
	$BlipSFX.play()
	timer_label.text = str(int_text)
	score_label.text = "Score: " + timer_label.text
	score_animator.play("pop")

## Callbacks
func _on_game_timer_timeout() -> void:
	var int_text = int(timer_label.text)
	int_text += 1
	$BlipSFX.pitch_scale = randf_range(0.8, 1.2)
	$BlipSFX.play()
	timer_label.text = str(int_text)
	score_label.text = "Score: " + timer_label.text
	score_animator.play("pop")

func _on_mob_timer_timeout() -> void:
	spawn_mob.emit()

func _on_coin_timer_timeout() -> void:
	spawn_coin.emit()
