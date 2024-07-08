extends StaticBody2D

@export var death_mineral : Mineral
@export var amount : int = 10

@onready var world : World = get_tree().get_first_node_in_group("world")

var is_dead: bool:
	get:
		return false

func _on_health_component_died() -> void:
	world.spawn_mineral_pickup(global_position, death_mineral, amount)
	SoundManager.play_sound_and_free(global_position, $DeathSound.stream)
	queue_free()
