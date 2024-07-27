extends HBoxContainer
class_name MineralCostGUI

@onready var amount_label: Label = $AmountLabel
@onready var mineral_icon: TextureRect = $MineralIcon

func set_cost(mineral: Mineral, amount: int) -> void:
	mineral_icon.texture = mineral.mineral_icon
	amount_label.text = str(GlobalFormat.format_amount(amount))
