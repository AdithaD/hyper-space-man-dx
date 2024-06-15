extends Control

@export var player: Player
@export var crosshair_texture: Texture2D

func _physics_process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var draw_position = get_global_mouse_position() - player.velocity * get_physics_process_delta_time()
	#draw_texture(crosshair_texture, draw_position)
