extends "res://gui/mineral_inventory_gui.gd"

@export var name_label: Label

var stack = []

func display(solar_object: SolarObject):
	name_label.text = solar_object.solar_name
	set_mineral_inventory(solar_object.mineral_inventory)
	_show()

func push(solar_object: SolarObject):
	stack.append(solar_object)
	display(stack.back())
	
func remove(solar_object: SolarObject):
	stack.erase(solar_object)
	if not stack.is_empty():
		display(stack.back())
	else:
		_hide()

func _hide():
	hide()
	name_label.hide()
func _show():
	show()
	name_label.show()
	
func _on_solar_system_spawner_solar_system_spawned(solar_system: SolarSystem) -> void:
	var solar_objects = solar_system.solar_objects

	for obj: SolarObject in solar_objects:
		obj.interact_area.player_entered.connect(_on_solar_object_entered.bind(obj))
		obj.interact_area.player_exited.connect(_on_solar_object_exited.bind(obj))
	
func _on_solar_object_entered(solar_object: SolarObject) -> void:
	push(solar_object)

func _on_solar_object_exited(solar_object: SolarObject) -> void:
	remove(solar_object)
