extends Node2D
class_name HeatEmitter

@export var radius : float = 1.0
@export var temperature : float

func get_energy(location: Vector2) -> float:
	var distance_to_edge := maxi(location.distance_to(global_position) - radius, 1)
	return pow(temperature, 4) / distance_to_edge
