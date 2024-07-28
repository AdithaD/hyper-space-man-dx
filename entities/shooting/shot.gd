extends Node2D
class_name Shot

@export var hitbox: HitboxComponent
@export var lifetime: float = 10.0
@export var starting_speed: float = 0.0

## the inherited velocity of the shot from the shot owner
var inherited_velocity: Vector2 = Vector2.ZERO;

## the source of the shot
var shot_owner: Node2D

var _forward_speed := 0.0

var _destination := Vector2.ZERO
var _timer: float = 0.0

func _ready() -> void:
	look_at(_destination)
	_forward_speed = starting_speed

func _physics_process(delta: float) -> void:
	_timer += delta
	if _timer > lifetime:
		queue_free()
		
	position += (transform.x * _forward_speed + inherited_velocity) * delta

func set_destination(new_destination: Vector2) -> void:
	_destination = new_destination
	look_at(_destination)

func set_damage(damage: int) -> void:
	$Hitbox.damage = damage

func _on_hitbox_collided(_hurtbox: HurtboxComponent) -> void:
	queue_free()
