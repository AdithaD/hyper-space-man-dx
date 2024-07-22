class_name MineralCost
extends Resource

@export var cost_dictionary = {}

func set_mineral_cost(mineral: Mineral, amount: int) -> void:
	if amount == 0:
		cost_dictionary.erase(mineral)

	cost_dictionary[mineral] = amount
	