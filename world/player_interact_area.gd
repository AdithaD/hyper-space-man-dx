extends Area2D
class_name PlayerInteractArea

signal player_entered(player: Player)
signal player_exited(player: Player)

func _ready() -> void:
	body_entered.connect(func(x: Node2D) -> void: if x.is_in_group("player"): player_entered.emit(x))
	body_exited.connect(func(x: Node2D) -> void: if x.is_in_group("player"): player_exited.emit(x))
