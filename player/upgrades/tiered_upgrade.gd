class_name TieredUpgrade
extends Resource

@export var upgrade_id: StringName
@export var upgrade_name: String
@export var tier_costs: Array[MineralInventory]
@export var tier_values: Array[float]

func get_tier_cost(tier: int) -> MineralInventory:
	if tier >= 0 and tier < tier_costs.size():
		return tier_costs[tier]
	else:
		return null

func get_tier_value(tier: int) -> float:
	if tier >= 0 and tier < tier_values.size():
		return tier_values[tier]
	else:
		return - 1

func get_max_tier():
	return min(tier_costs.size(), tier_values.size() - 1)