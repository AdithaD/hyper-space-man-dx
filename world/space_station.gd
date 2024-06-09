class_name SpaceStation
extends Node2D

@export var cost_per_unit : float = 10
@export var cost_mineral : Mineral

var interact_area:
	get:
		return $PlayerInteractArea

func _on_player_interact_area_player_entered() -> void:
	pass # Replace with function body.


func _on_player_interact_area_player_exited() -> void:
	pass # Replace with function body.
