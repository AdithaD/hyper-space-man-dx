extends Control

@export var player: Player
@export var upgrades: Array[TieredUpgrade]
@export var upgrades_gui_list_item: PackedScene

func _ready() -> void:
	%UpgradeDetailsGUI.player = player
	for upgrade: TieredUpgrade in upgrades:
		var instance := upgrades_gui_list_item.instantiate()
		instance.upgrade = upgrade

		var upgrade_minerals := upgrade.get_tier_cost(player.get_tier(upgrade)).get_minerals()
		var player_minerals := player.mineral_inventory.get_minerals()

		var is_subset := not false in upgrade_minerals.map(func(m: Mineral) -> bool: return m in player_minerals)
		prints(upgrade.upgrade_name, is_subset)
		if player.get_tier(upgrade) != 0 or is_subset:
			%UpgradeItemList.append_item(instance)
	
	if %UpgradeItemList.items.size() > 0:
		%UpgradeItemList.items[0].is_selected = true
	print("upgrade ready")
	
func _on_upgrade_item_list_item_selected(item: Control) -> void:
	%UpgradeDetailsGUI.set_upgrade(item.upgrade)
