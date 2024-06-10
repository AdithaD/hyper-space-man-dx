extends AnimatedSprite2D

@export var rotation_speed : float

@export var rotation_enabled = true

func _physics_process(delta: float) -> void:
	if rotation_enabled:
		rotation = fmod(delta * rotation_speed + rotation, 2 * PI)
