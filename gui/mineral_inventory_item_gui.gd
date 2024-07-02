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
			amount_label.text = format_amount(amount)

		show()
	else:
		hide()

func format_amount(amount : int) -> String:
	var pow := log(amount) / log(10)
	var suffix := ""
	if pow >= 3:
		suffix = "K"
	elif pow >= 6:
		suffix = "M"
	
	var quotient : float = amount if pow < 3 else amount / pow(10, floori(pow/3) * 3)
	return ("%.1f%s" if pow > 3 else "%.0f%s") % [quotient, suffix]
