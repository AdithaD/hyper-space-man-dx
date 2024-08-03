class_name MineralInventory
extends Resource

signal mineral_modified(mineral: Mineral, new_amount: int)
signal new_mineral_added(mineral: Mineral)

@export var starting_inventory := {}: set = _init

var inventory := {}

func _init(p_starting_inventory: Dictionary={}) -> void:
	starting_inventory = p_starting_inventory

	for m: Mineral in starting_inventory.keys():
		inventory[m] = starting_inventory.get(m, 0)
		mineral_modified.emit(m, inventory[m])
		
func add_amount(mineral: Mineral, amount: int) -> void:
	var new_mineral := not inventory.has(mineral)

	inventory[mineral] = inventory.get(mineral, 0) + amount
	
	if new_mineral:
		new_mineral_added.emit(mineral)

	mineral_modified.emit(mineral, inventory[mineral])

func remove_amount(mineral: Mineral, amount: int) -> void:
	if inventory.has(mineral):
		inventory[mineral] = max(inventory[mineral] - amount, 0)
		mineral_modified.emit(mineral, inventory[mineral])
	else:
		push_warning("Tried to remove mineral that is not in inventory")

func clear() -> void:
	inventory.clear()

func get_amount(mineral: Mineral) -> int:
	return inventory.get(mineral, 0)

func has_amount(mineral: Mineral, minimum: int) -> bool:
	return inventory.get(mineral, 0) >= minimum

func get_minerals() -> Array[Mineral]:
	var _arr: Array[Mineral] = []
	_arr.assign(inventory.keys())
	return _arr

func get_total_minerals() -> int:
	return inventory.keys().reduce(func(sum: int, m: Mineral) -> int: return sum + get_amount(m), 0)
	
func generate_assortment(amount: int) -> Dictionary:
	var remaining := amount
	var _minerals: Array[Mineral] = []
	_minerals.assign(inventory.keys().duplicate())
	_minerals.shuffle()

	var take := {}
	for i in range(_minerals.size()):
		var mineral: Mineral = _minerals.pop_back()
		var take_size: int = remaining / (_minerals.size() + 1)
		var actual_take: int = min(get_amount(mineral), take_size)
		
		take[mineral] = actual_take
		remaining -= actual_take
	
	return take

func is_superset(other: MineralInventory) -> bool:
	return other.get_minerals().reduce(func(acc: bool, m: Mineral) -> bool: return acc and has_amount(m, other.get_amount(m)), true)

func remove_subset(other: MineralInventory) -> void:
	for mineral in other.get_minerals():
		remove_amount(mineral, other.get_amount(mineral))
