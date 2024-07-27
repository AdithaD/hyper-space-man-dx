extends InteractionDelegate

@export var space_station_gui: Control

func interact(source_node: Node2D) -> void:
	space_station_gui.set_space_station(source_node)
	space_station_gui.show()
	super(source_node)
	
func finish_interaction(source_node: Node2D) -> void:
	space_station_gui.hide()
	super(source_node)