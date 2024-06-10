extends Resource

@export var minerals: Array[Mineral] = []
@export var mineral_quantity_curves = {}

@export var mineral_amount_scale := 1000
@export var mineral_amount_curve: Curve = Curve.new()

func _init(p_mineral_quantity_curves={}, p_mineral_amount_curve: Curve=Curve.new()) -> void:
	mineral_quantity_curves = p_mineral_quantity_curves
	mineral_amount_curve = p_mineral_amount_curve
	
func generate_mineral_inventory(weight) -> MineralInventory:
	var amount_of_minerals = roundi(mineral_amount_curve.sample(randf_range(weight, 1.0)))
	amount_of_minerals = min(minerals.size(), amount_of_minerals)
	
	var mineral_amounts = {}
	var _minerals: Array[Mineral] = []
	for i in range(amount_of_minerals):
		var mineral = minerals.filter(func(m): return not _minerals.has(m)).pick_random()
		_minerals.append(mineral)

		var amount = mineral_quantity_curves.get(mineral, Curve.new()).sample(randf_range(weight, 1.0)) * mineral_amount_scale
		mineral_amounts[mineral] = amount
	
	var mineral_inventory = MineralInventory.new(_minerals, mineral_amounts)
	return mineral_inventory
