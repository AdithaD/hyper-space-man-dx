extends Node

signal stack_changed(top: SolarObject)

var stack = []

var current_solar_object:
	get:
		return stack.back() if not stack.is_empty() else null

func push(solar_object: SolarObject):
	stack.append(solar_object)
	stack_changed.emit(stack.back())
	
func remove(solar_object: SolarObject):
	stack.erase(solar_object)
	if not stack.is_empty():
		stack_changed.emit(stack.back())
	else:
		stack_changed.emit(null)

func _on_solar_system_spawner_solar_system_spawned(solar_system: SolarSystem) -> void:
	var solar_objects = solar_system.solar_objects

	for obj: SolarObject in solar_objects:
		obj.interact_area.player_entered.connect(_on_solar_object_entered.bind(obj))
		obj.interact_area.player_exited.connect(_on_solar_object_exited.bind(obj))
	
func _on_solar_object_entered(solar_object: SolarObject) -> void:
	push(solar_object)

func _on_solar_object_exited(solar_object: SolarObject) -> void:
	remove(solar_object)
