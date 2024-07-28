extends InteractionDelegate

@export var space_station_gui: Control
@export var menu_manager: ExclusiveMenuManager

func interact(source_node: Node2D) -> void:
	super(source_node)
	
	if _interacting_node:
		space_station_gui.set_space_station(_interacting_node)
		
		player.movement_override = true
		
		var tween := create_tween()
		tween.tween_method(_interpolate_to_space_station.bind(_interacting_node), player.global_position - _interacting_node.global_position, Vector2(), 0.5).set_ease(Tween.EASE_OUT)
		tween.tween_callback(menu_manager.try_open_menu.bind(space_station_gui))

func _physics_process(_delta: float) -> void:
	if _interacting_node:
		player.global_position = _interacting_node.global_position

func _interpolate_to_space_station(offset: Vector2, source_node: Node2D, ) -> void:
	player.global_position = source_node.global_position + offset

func finish_interaction(source_node: Node2D) -> void:
	menu_manager.close_menu(space_station_gui)
	player.movement_override = false
	if _interacting_node:
		player.velocity = _interacting_node.last_velocity
	super(source_node)
