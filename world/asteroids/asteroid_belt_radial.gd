extends Node2D

@export var asteroid_scenes : Array[PackedScene]

@export var min_radius: float = 0
@export var max_radius: float = 0
@export var amount_of_segements : float = 8.0
@export var asteroids_per_segment : float = 2.0
@export var segments_per_batch := 4.0

@onready var increment := 2 * PI / amount_of_segements
var spawned_segments := 0
var spawning := false

func _generate() -> void:
	spawning = true

func _physics_process(delta: float) -> void:
	if spawning:
		var batch_size := mini(segments_per_batch, amount_of_segements - spawned_segments)
		_spawn_batch(batch_size)

func _spawn_batch(batch_size : int) -> void:
	for i in range(batch_size):
		for n in range(asteroids_per_segment):
			_spawn_asteroid(spawned_segments * increment)
		spawned_segments += 1

	spawning = spawned_segments != amount_of_segements
	print(spawned_segments)

func _spawn_asteroid(angle: float) -> void:
	var variance_angle := randf_range(-PI / amount_of_segements, PI / amount_of_segements)
	var radius := randf_range(min_radius, max_radius)
	var spawn_position := Vector2(radius, 0).rotated(angle + variance_angle)
	
	var instance : Node2D = asteroid_scenes.pick_random().instantiate()
	#instance.velocity = _velocity
	
	add_child(instance)
	instance.position = spawn_position
