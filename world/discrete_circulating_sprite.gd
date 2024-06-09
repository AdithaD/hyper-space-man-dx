extends Sprite2D

@export var radius : int = 4
@export var angular_speed : float = PI

var _timer = 0.0

func _ready() -> void:
	offset = Vector2.RIGHT * radius

func _process(delta: float) -> void:
	_timer += delta
	if _timer > angular_speed / 4:
		offset = offset.rotated(PI / 2)
		_timer = 0.0
