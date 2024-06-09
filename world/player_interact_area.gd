extends Area2D

signal player_entered
signal player_exited

func _ready() -> void:
	body_entered.connect(func(x): if x.is_in_group("player"): player_entered.emit())
	body_exited.connect(func(x): if x.is_in_group("player"): player_exited.emit())
