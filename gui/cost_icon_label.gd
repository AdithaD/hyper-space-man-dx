extends HBoxContainer

@onready var label: Label = $UpgradeCostLabel
@onready var icon: TextureRect = $TextureRect

func set_mineral(mineral: Mineral, value: int) -> void:
	label.text = str(value)
	icon.texture = mineral.mineral_icon
