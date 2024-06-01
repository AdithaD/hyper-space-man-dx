extends SubViewport

@export var world : World
@export var player : Player

@export var scale : float = 1.0

func _ready() -> void:
	world_2d = world.get_world_2d()

func _physics_process(delta: float) -> void:
	$Camera2D.global_position = player.global_position
	pass
