extends Node

@export var upgrades: Array[TieredUpgrade] = []

var _upgrade_map = {}

func _ready():
    for upgrade in upgrades:
        _upgrade_map[upgrade.upgrade_id] = upgrade

func can_upgrade(player: Player, upgrade_name: StringName) -> bool:
    var upgrade = find_upgrade(upgrade_name)

    return player.mineral_inventory.is_superset(upgrade.current_cost)

func apply_upgrade(player: Player, upgrade_name: StringName) -> void:
    var upgrade = find_upgrade(upgrade_name)
    # take minerals from player
    player.mineral_inventory.remove_subset(upgrade.current_cost)
    upgrade.apply(player)
    
func find_upgrade(upgrade_name: StringName) -> TieredUpgrade:
    return _upgrade_map.get(upgrade_name)