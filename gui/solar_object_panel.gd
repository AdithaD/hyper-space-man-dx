extends Control

@export var name_label : Label
@export var mineral_inventory_gui : Control

var _solar_object : SolarObject

func display(solar_object: SolarObject) -> void:
	name_label.text = solar_object.solar_name
	mineral_inventory_gui.set_mineral_inventory(solar_object.mineral_inventory)
	_show()

func _hide() -> void:
	hide()
	name_label.hide()

func _show() -> void:
	show()
	name_label.show()

func _on_player_mining_interactor_stack_changed(top: SolarObject) -> void:
	if top:
		display(top)
	else:
		_hide()
