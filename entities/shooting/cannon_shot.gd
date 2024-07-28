extends Shot
class_name CannonShot

@export var acceleration: float = 1000.0
@export var max_speed: float = 600

@export var allow_negative_speed := false

func _physics_process(delta: float) -> void:
	_forward_speed += acceleration * delta
	if not allow_negative_speed and _forward_speed < 0:
		_forward_speed = 0
		
	super(delta)
