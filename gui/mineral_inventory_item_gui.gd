extends HBoxContainer
class_name MineralInventoryItemGUI

@export var mineral: Mineral

@export var texture_rect : TextureRect
@export var name_label : Label
@export var amount_label : Label

func set_mineral(value: Mineral, amount := 0) -> void:
	mineral = value
	update(amount)

func update(amount: int = 0) -> void:
	if mineral:
		if texture_rect:
			texture_rect.texture = mineral.mineral_icon

		if name_label:
			name_label.text = mineral.mineral_name

		if amount_label:
			amount_label.text = GlobalFormat.format_amount(amount)

		show()
	else:
		hide()
