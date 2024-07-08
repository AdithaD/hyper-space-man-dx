extends VBoxContainer

@export var player: Player
@export var mineral_cost_item : PackedScene

@onready var upgrade_name_label: Label = %UpgradeNameLabel
@onready var upgrade_level_label: Label = %UpgradeLevelLabel

@onready var from_value_label: Label = %FromValueLabel
@onready var to_value_label: Label = %ToValueLabel

@onready var mineral_cost_list: HBoxContainer = %MineralCostList
@onready var upgrade_button: Button = %UpgradeButton
@onready var upgrade_value_container: HBoxContainer = %UpgradeValueContainer

var _upgrade : TieredUpgrade

func set_upgrade(upgrade: TieredUpgrade) -> void:
	_upgrade =upgrade
	upgrade_name_label.text = upgrade.upgrade_name
	
	var current_tier : int = player.get_tier(upgrade)
	
	if upgrade.get_max_tier() != current_tier:
		upgrade_level_label.text = "LVL %d > %d" % [current_tier + 1, current_tier + 2]
		
		from_value_label.text = GlobalFormat.format_amount(floori(upgrade.get_tier_value(current_tier)))
		to_value_label.text = GlobalFormat.format_amount(floori(upgrade.get_tier_value(current_tier + 1)))

		var cost := upgrade.get_tier_cost(current_tier)
		
		for child in mineral_cost_list.get_children():
			child.queue_free()
		
		for mineral in cost.get_minerals():
			var item_gui := mineral_cost_item.instantiate()
			mineral_cost_list.add_child(item_gui)
			item_gui.set_data(mineral, cost.get_amount(mineral))

		upgrade_button.disabled = not player.mineral_inventory.is_superset(cost) or upgrade.get_max_tier() == player.get_tier(upgrade)
		upgrade_level_label.hide()
		upgrade_value_container.show()
		mineral_cost_list.show()
		upgrade_button.show()

	else:
		upgrade_level_label.text = "MAX LEVEL"
		upgrade_level_label.show()
		upgrade_value_container.hide()
		mineral_cost_list.hide()
		upgrade_button.hide()
		
	pass

func _on_upgrade_button_pressed() -> void:
	player.apply_upgrade(_upgrade)
	set_upgrade(_upgrade)
	$UpgradeSound.play()
