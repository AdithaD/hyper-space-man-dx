class_name MineralInventory
extends Resource

signal mineral_modified(mineral: Mineral, new_amount: int)

@export var minerals: Array[Mineral]
@export var starting_inventory = {}

var inventory := {}

func _init(p_minerals: Array[Mineral]=[], p_starting_inventory=null) -> void:
	minerals = p_minerals
	starting_inventory = p_starting_inventory
	
	for m in minerals:
		inventory[m] = starting_inventory.get(m, 0)
		mineral_modified.emit(m, inventory[m])
		
func add_amount(mineral: Mineral, amount: int):
	inventory[mineral] += amount
	mineral_modified.emit(mineral, inventory[mineral])

func remove_amount(mineral: Mineral, amount: int):
	inventory[mineral] = max(inventory[mineral] - amount, 0)
	mineral_modified.emit(mineral, inventory[mineral])

func get_amount(mineral: Mineral) -> int:
	return inventory.get(mineral, 0)

func has_amount(mineral: Mineral, minimum: int) -> bool:
	return inventory.get(mineral, 0) >= minimum
