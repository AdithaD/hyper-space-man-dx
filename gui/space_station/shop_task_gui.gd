extends VBoxContainer

signal single_task_purchased
signal all_task_purchased

@export var title: String

@onready var single_task_button: Button = %RestoreOneButton
@onready var all_task_button: Button = %RestoreAllButton

@onready var title_label: Label = %TitleLabel
@onready var mineral_cost_label: Label = %MineralCostLabel
@onready var mineral_icon_texture_rect: TextureRect = %MineralIconTextureRect

func _ready() -> void:
	title_label.text = title

	single_task_button.pressed.connect(single_task_purchased.emit)
	all_task_button.pressed.connect(all_task_purchased.emit)

func set_cost(mineral: Mineral, amount: int) -> void:
	mineral_icon_texture_rect.texture = mineral.mineral_icon
	mineral_cost_label.text = str(GlobalFormat.format_amount(amount))

func update(deficiency: int, purchasable_amount: int) -> void:
	single_task_button.disabled = deficiency == 0 or purchasable_amount == 0
	all_task_button.disabled = deficiency > purchasable_amount or deficiency == 0 or purchasable_amount == 0