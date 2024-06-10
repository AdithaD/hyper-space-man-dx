extends "res://gui/mineral_inventory_gui.gd"

@export var name_label: Label

func display(solar_object: SolarObject):
	name_label.text = solar_object.solar_name
	set_mineral_inventory(solar_object.mineral_inventory)
	_show()

func _hide():
	hide()
	name_label.hide()

func _show():
	show()
	name_label.show()

func _on_player_mining_interactor_stack_changed(top) -> void:
	if top:
		display(top)
	else:
		_hide()