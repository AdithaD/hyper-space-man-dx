extends Node2D

@export var target_group: StringName
@export var speed: float = 900.0
@export var acceleration = 450.0
@export var lifetime = 10.0
@export var angular_speed = PI / 2

var dir: Vector2
var base_velocity: Vector2 = Vector2.ZERO;
var local_speed: float = 0.0;

var _timer = 0.0

var target_body: Node2D

func _ready() -> void:
	var nearest_body = get_tree().get_nodes_in_group(target_group) \
		.reduce(func(nearest, x): return nearest if nearest.global_position.distance_to(global_position) < x.global_position.distance_to(global_position) else x)
	target_body = nearest_body as Node2D

func _physics_process(delta: float) -> void:
	if target_body:
		dir = global_position.direction_to(target_body.global_position)
		var percent_of_max_speed = local_speed / speed
		var angle = transform.x.angle_to(dir)
		angle = sign(angle) * min(angular_speed * delta * percent_of_max_speed, abs(angle))
		rotate(angle)
		#look_at(target_body.global_position)
		
	local_speed += acceleration * delta
	local_speed = min(speed, local_speed)
	
	position += (transform.x * local_speed + base_velocity) * delta

	_timer += delta
	if _timer > lifetime:
		queue_free()

func _on_hitbox_collided(_hurtbox: HurtboxComponent) -> void:
	queue_free()
