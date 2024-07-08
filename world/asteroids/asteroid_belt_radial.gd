extends Node2D

@export var asteroid_scenes : Array[PackedScene]

@export var min_radius: float = 0
@export var max_radius: float = 0
@export var amount_of_segements : float = 8.0
@export var asteroids_per_segment : float = 2.0

func _generate() -> void:
	var increment := 2 * PI / amount_of_segements
	
	for i in range(amount_of_segements):
		for n in range(asteroids_per_segment):
			_spawn_asteroid(i * increment)

func _spawn_asteroid(angle: float) -> void:
	var variance_angle := randf_range(-PI / amount_of_segements, PI / amount_of_segements)
	var radius := randf_range(min_radius, max_radius)
	var spawn_position := Vector2(radius, 0).rotated(angle + variance_angle)
	
	var instance : Node2D = asteroid_scenes.pick_random().instantiate()
	#instance.velocity = _velocity
	
	add_child(instance)
	instance.position = spawn_position
