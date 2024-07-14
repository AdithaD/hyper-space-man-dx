extends Node2D

@export var asteroid_scenes : Array[PackedScene]

@export var angle : float = 0.0
@export var width : float = 256
@export var height : float = 2048
@export var band_height : float = 256
@export var asteroids_per_band : float = 2.0
@export var drift_speed : float = 64
var _velocity := Vector2()

var spawning := false

func _ready() -> void:
	_velocity = Vector2(drift_speed, 0).rotated(2 * PI * randf())
	_generate()

func _generate() -> void:
	var amount_of_bands := floori(height / band_height)
	
	var y := -height / 2
	
	for i in range(amount_of_bands):
		for n in range(asteroids_per_band):
			_spawn_asteroid(y)

func _spawn_asteroid(y: float) -> void:
	var x := randi_range(-width / 2, width / 2)
	var spawn_position := Vector2(x, y).rotated(angle)
	
	var instance : Node2D = asteroid_scenes.pick_random().instantiate()
	instance.velocity = _velocity
	
	add_child(instance)
	instance.position = spawn_position
