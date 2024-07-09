extends Area2D
class_name PlayerInteractArea

signal player_entered(player: Player)
signal player_exited(player: Player)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		player_entered.emit(body)
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): 
		player_exited.emit(body)
