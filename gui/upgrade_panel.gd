extends PanelContainer

@export var cost_label_scene: PackedScene
@export var player: Player

@export var upgrade: TieredUpgrade

func _ready():
	player.upgraded.connect(update)
	player.mineral_inventory.mineral_modified.connect(update.unbind(2))
	set_upgrade(upgrade, player.get_tier(upgrade))

func update():
	set_upgrade(upgrade, player.get_tier(upgrade))

func set_upgrade(new_upgrade: TieredUpgrade, tier: int=0) -> void:
	upgrade = new_upgrade
	# name
	%NameLabel.text = upgrade.upgrade_name
	# change in value

	if player.get_tier(upgrade) < upgrade.get_max_tier():
		%FromCostLabel.text = str(upgrade.get_tier_value(tier))
		%ToCostLabel.text = str(upgrade.get_tier_value(tier + 1))

		var cost = upgrade.get_tier_cost(tier)

		for child in %CostIconParent.get_children():
			child.queue_free()

		if cost:
			for mineral in cost.get_minerals():
				var label = cost_label_scene.instantiate()
				%CostIconParent.add_child(label)
				label.set_mineral(mineral, cost.get_amount(mineral))

		# button status
		%UpgradeButton.disabled = not player.can_upgrade(upgrade)
	else:
		%MaxedOutLabel.show()
		%UpgradeData.hide()

func _on_upgrade_button_pressed():
	player.apply_upgrade(upgrade)
