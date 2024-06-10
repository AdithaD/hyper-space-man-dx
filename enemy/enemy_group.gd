class_name EnemyGroup
extends Node2D

@export var max_distance_from_home: float = 1600

var home_solar_system: SolarSystem

var exploration_vector: Vector2

func _ready() -> void:
	exploration_vector = Vector2.RIGHT.rotated(randf_range( - 1, 1) * PI)

	for child in get_children():
		child.group = self
		child.exploration_vector = exploration_vector

func _caculate_exploration_vector():
	var children = get_children()
	var com = children.reduce(func(sum, x): return sum + x.global_position, Vector2.ZERO) / children.size()

	if com.distance_to(home_solar_system.global_position) > max_distance_from_home:
		var dir = com.direction_to(home_solar_system.global_position)
		exploration_vector = dir.rotated(randf_range( - PI / 4, PI / 4))