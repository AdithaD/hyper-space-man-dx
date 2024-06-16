class_name MineralInventory
extends Resource

signal mineral_modified(mineral: Mineral, new_amount: int)

@export var starting_inventory = {}: set = _init

var inventory := {}

func _init(p_starting_inventory=null) -> void:
	starting_inventory = p_starting_inventory

	if starting_inventory:
		for m in starting_inventory.keys():
			inventory[m] = starting_inventory.get(m, 0)
			mineral_modified.emit(m, inventory[m])
		
func add_amount(mineral: Mineral, amount: int):
	inventory[mineral] = inventory.get(mineral, 0) + amount
	mineral_modified.emit(mineral, inventory[mineral])

func remove_amount(mineral: Mineral, amount: int):
	if inventory.has(mineral):
		inventory[mineral] = max(inventory[mineral] - amount, 0)
		mineral_modified.emit(mineral, inventory[mineral])
	else:
		push_warning("Tried to remove mineral that is not in inventory")

func get_amount(mineral: Mineral) -> int:
	return inventory.get(mineral, 0)

func has_amount(mineral: Mineral, minimum: int) -> bool:
	return inventory.get(mineral, 0) >= minimum

func get_minerals():
	return inventory.keys()

func get_total_minerals() -> int:
	return inventory.keys().reduce(func(sum, m): return sum + get_amount(m), 0)
	
func generate_assortment(amount: int) -> Dictionary:
	var remaining = amount
	var _minerals = inventory.keys().duplicate()
	_minerals.shuffle()

	var take = {}
	for i in range(_minerals.size()):
		var mineral = _minerals.pop_back()
		var take_size = remaining / (_minerals.size() + 1)
		var actual_take = min(get_amount(mineral), take_size)
		
		take[mineral] = actual_take
		remaining -= actual_take
	
	return take

func is_superset(other: MineralInventory) -> bool:
	return other.get_minerals().reduce(func(acc, m): return acc and has_amount(m, other.get_amount(m)), true)

func remove_subset(other: MineralInventory):
	for mineral in other.get_minerals():
		remove_amount(mineral, other.get_amount(mineral))
