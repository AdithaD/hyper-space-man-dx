extends Node2D
class_name HeatEmitter

@export var radius : float = 1.0
@export var temperature : float

func get_energy(location: Vector2) -> float:
	var distance := maxi(location.distance_to(global_position), radius)
	return pow(temperature, 4) / pow(distance, 2)
