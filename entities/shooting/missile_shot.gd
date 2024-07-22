extends Shot
class_name MissileShot

@export var max_speed: float = 1600.0
@export var base_acceleration: float = 450.0
@export var jerk: float = 7000.0
@export var angular_speed: float = PI / 2
@export var burn_time: float = 3.0

@export var target_body: Node2D

var dir: Vector2

var _acceleration: float = 0.0
var is_accelerating := false

func _ready() -> void:
	var tangent := (global_position.direction_to(target_body.global_position) + inherited_velocity).normalized().orthogonal()
	var tween := create_tween()
	tween.tween_property(self, "position", position + tangent * 72, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func() -> void: is_accelerating=true)

func _physics_process(delta: float) -> void:
	if is_accelerating and _timer < burn_time:

		if target_body:
			dir = global_position.direction_to(target_body.global_position)
			var percent_of_max_speed: float = _forward_speed / max_speed
			var angle := transform.x.angle_to(dir)
			angle = sign(angle) * min(angular_speed * delta * percent_of_max_speed, abs(angle))
			rotate(angle)

		_acceleration += jerk * delta
		_forward_speed += _acceleration * delta
		_forward_speed = min(max_speed, _forward_speed)
	
	super(delta)

func set_target(target: Node2D) -> void:
	target_body = target
