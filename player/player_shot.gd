extends Node2D

@export var target : Vector2
@export var speed : float = 900.0
@export var acceleration = 1000.0
@export var lifetime = 10.0

var dir : Vector2
var base_velocity : Vector2 = Vector2.ZERO;
var local_speed : float = 0.0;

var _timer = 0.0

func set_target(target: Vector2, base_velocity: Vector2):
	self.target = target
	self.base_velocity = base_velocity
	dir = global_position.direction_to(target)
	look_at(target)

func _physics_process(delta: float) -> void:
	local_speed += acceleration * delta
	local_speed = min(speed, local_speed)
	
	position += (dir * local_speed + base_velocity) * delta

	_timer += delta
	if _timer > lifetime:
		queue_free()
