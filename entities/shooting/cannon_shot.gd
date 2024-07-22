extends Shot
class_name CannonShot

@export var acceleration: float = 1000.0
@export var max_speed: float = 600

func _physics_process(delta: float) -> void:
	_forward_speed += acceleration * delta
	super(delta)
