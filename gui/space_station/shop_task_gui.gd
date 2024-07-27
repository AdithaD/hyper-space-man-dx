extends VBoxContainer

signal purchased(amount: int)

@export var title: String

@onready var ten_percent_task_button: Button = %FixTenPercentButton
@onready var ten_percent_mineral_cost: MineralCostGUI = %TenPercentMineralCost

@onready var fix_all_button: Button = %FixAllButton
@onready var all_mineral_cost: MineralCostGUI = %AllMineralCost

@onready var title_label: Label = %TitleLabel

var ten_percent: int
var all: int

func _ready() -> void:
	title_label.text = title

	ten_percent_task_button.pressed.connect(_on_partial_button_pressed)
	fix_all_button.pressed.connect(_on_all_button_pressed)

func update(cost_mineral: Mineral, cost_per_unit: float, deficiency: float, maximum: float, purchasable_amount: int) -> void:
	ten_percent = mini(ceili(maximum / 10), ceili(deficiency))
	all = ceili(deficiency)

	ten_percent_mineral_cost.set_cost(cost_mineral, ceili(ten_percent * cost_per_unit))
	ten_percent_task_button.text = str("FIX ", ten_percent)

	all_mineral_cost.set_cost(cost_mineral, ceili(deficiency * cost_per_unit))

	ten_percent_task_button.disabled = purchasable_amount < ten_percent or ten_percent == 0
	fix_all_button.disabled = deficiency > purchasable_amount or deficiency == 0 or purchasable_amount == 0

func _on_partial_button_pressed() -> void:
	purchased.emit(ten_percent)

func _on_all_button_pressed() -> void:
	purchased.emit(all)