extends Node2D

@export var target_group: StringName
@export var speed: float = 1600.0
@export var jerk: float = 7000.0
@export var base_acceleration : float = 450.0
@export var lifetime : float = 10.0
@export var angular_speed : float = PI / 2

var dir: Vector2
var base_velocity: Vector2 = Vector2.ZERO;
var local_speed: float = 0.0;

var _acceleration : float = 0.0
var _timer : float = 0.0

var player: Player

var target_body: Node2D
var accelerating := false

func _ready() -> void:
	target_body = player.target_lock.get_current_target()
	var tangent := (global_position.direction_to(target_body.global_position) + base_velocity).normalized().orthogonal()
	var tween := create_tween()
	tween.tween_property(self, "position", position + tangent * 72, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func() -> void: accelerating = true)

func _physics_process(delta: float) -> void:
	if accelerating:
		if target_body:
			dir = global_position.direction_to(target_body.global_position)
			#dir = global_position.direction_to(get_global_mouse_position())
			var percent_of_max_speed : float = local_speed / speed
			var angle := transform.x.angle_to(dir)
			angle = sign(angle) * min(angular_speed * delta * percent_of_max_speed, abs(angle))
			rotate(angle)
			#look_at(target_body.global_position)
		_acceleration += jerk * delta
		local_speed += _acceleration * delta
		local_speed = min(speed, local_speed)
		
		position += (transform.x * local_speed + base_velocity) * delta

	_timer += delta
	if _timer > lifetime:
		queue_free()

func set_damage(damage: int) -> void:
	$Hitbox.damage = damage
	
func _on_hitbox_collided(_hurtbox: HurtboxComponent) -> void:
	queue_free()
