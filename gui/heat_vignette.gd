extends Control

@export var player: Player
@export var minimum_ratio: float = 0.6

func _physics_process(_delta: float) -> void:
	modulate.a = clampf(player.heat_receiver.get_ratio() - minimum_ratio, 0.0, minimum_ratio) / minimum_ratio
