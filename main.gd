extends Node

@onready var player: Player = $Player
@onready var world: World = $World

func _ready() -> void:
	world.configure_player(player)
	world.start()
	player.died.connect(_start_game_over_sequence)

func _on_prompt_prompt_interacted(object: Object) -> void:
	if object is SpaceStation:
		var space_station = object as SpaceStation
		space_station.fill(player)

func restart_game() -> void:
	get_tree().reload_current_scene()

func _on_restart_button_pressed() -> void:
	restart_game()

func _start_game_over_sequence():
	$AnimationPlayer.play("game_over")
