extends Node

@export var winning_speed : float = 299000

var game_won : bool = false
var start_time : int = 0

@onready var player: Player = $Player
@onready var world: World = $World
@onready var win_timer: Timer = $WinTimer

func _ready() -> void:
	world.configure_player(player)
	world.start()
	start_time = Time.get_ticks_msec()
	player.died.connect(_start_game_over_sequence)

func _physics_process(delta: float) -> void:
	if player.velocity.length() > 299900 and not game_won:
		if win_timer.is_stopped():
			win_timer.start()
	else:
		if not win_timer.is_stopped():
			win_timer.stop()

func _on_prompt_prompt_interacted(object: Object) -> void:
	if object is SpaceStation:
		var space_station := object as SpaceStation
		space_station.fill(player)


func restart_game() -> void:
	get_tree().reload_current_scene()

func _on_restart_button_pressed() -> void:
	restart_game()

func _start_game_over_sequence() -> void:
	$AnimationPlayer.play("game_over")


func _on_win_timer_timeout() -> void:
	game_won = true
	$AnimationPlayer.play("win")
	if %WinTimeLabel:
		var seconds := roundi((Time.get_ticks_msec() - start_time) / 1000)
		%WinTimeLabel.text = "in %d seconds" % seconds
