extends Control

@export var player: Player
@export var upgrades: Array[TieredUpgrade]
@export var upgrades_gui_list_item: PackedScene

@onready var upgrade_item_list: VBoxContainer = %UpgradeItemList
@onready var upgrade_details_gui: VBoxContainer = %UpgradeDetailsGUI


func _ready() -> void:
	upgrade_details_gui.player = player
	_rebuild_items()
	player.mineral_inventory.new_mineral_added.connect(_rebuild_items.unbind(1))

func _rebuild_items() -> void:
	upgrade_item_list.clear()
	
	for upgrade: TieredUpgrade in upgrades:
		var instance := upgrades_gui_list_item.instantiate()
		instance.upgrade = upgrade

		var upgrade_minerals := upgrade.get_tier_cost(player.get_tier(upgrade)).get_minerals()
		var player_minerals := player.mineral_inventory.get_minerals()

		var is_subset := not false in upgrade_minerals.map(func(m: Mineral) -> bool: return m in player_minerals)
		prints(upgrade.upgrade_name, is_subset)
		if player.get_tier(upgrade) != 0 or is_subset:
			upgrade_item_list.append_item(instance)
		
	print("upgrade ready")
	
func _on_upgrade_item_list_item_selected(item: Control) -> void:
	%UpgradeDetailsGUI.set_upgrade(item.upgrade)
