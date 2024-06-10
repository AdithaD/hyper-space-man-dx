extends Node2D

@export var target: Vector2
@export var speed: float = 900.0
@export var acceleration = 1000.0
@export var lifetime = 10.0

var dir: Vector2
var inherited_velocity: Vector2 = Vector2.ZERO;
var local_speed: float = 0.0;

var _timer = 0.0

func set_target(new_target: Vector2):
	target = new_target
	dir = global_position.direction_to(target)
	look_at(target)

func set_damage(damage: int) -> void:
	$Hitbox.damage = damage

func set_inherited_velocity(velocity: Vector2) -> void:
	inherited_velocity = velocity

func _physics_process(delta: float) -> void:
	local_speed += acceleration * delta
	local_speed = min(speed, local_speed)
	
	position += (dir * local_speed + inherited_velocity) * delta

	_timer += delta
	if _timer > lifetime:
		queue_free()

func _on_hitbox_collided(_hurtbox: HurtboxComponent) -> void:
	queue_free()
