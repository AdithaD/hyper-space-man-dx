extends Control

@export var player : Player
@export var upgrades : Array[TieredUpgrade]
@export var upgrades_gui_list_item : PackedScene

func _ready() -> void:
	%UpgradeDetailsGUI.player = player
	for upgrade in upgrades:
		var instance := upgrades_gui_list_item.instantiate()
		instance.upgrade = upgrade
		%UpgradeItemList.append_item(instance)
	
	%UpgradeItemList.items[0].is_selected = true
	
func _on_upgrade_item_list_item_selected(item: Control) -> void:
	%UpgradeDetailsGUI.set_upgrade(item.upgrade)
	
