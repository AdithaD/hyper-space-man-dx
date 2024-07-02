extends VBoxContainer
@onready var icon: TextureRect = $MineralIconTextureRect
@onready var amount_label: Label = $AmountLabel

func set_data(mineral : Mineral, amount: int) -> void:
	icon.texture = mineral.mineral_icon
	amount_label.text = str(GlobalFormat.format_amount(amount))
	
