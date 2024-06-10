extends Control

const MINERAL_INVENTORY_ITEM_GUI = preload ("res://gui/mineral_inventory/mineral_inventory_item_gui.tscn")

@export var mineral_inventory: MineralInventory: set = set_mineral_inventory

var mineral_to_child_map = {}

func _ready() -> void:
	if mineral_inventory:
		set_mineral_inventory(mineral_inventory)
	
func set_mineral_inventory(value: MineralInventory) -> void:
	if mineral_inventory:
		if mineral_inventory.mineral_modified.is_connected(_on_mineral_modified):
			mineral_inventory.mineral_modified.disconnect(_on_mineral_modified)
	
	mineral_inventory = value
	update()
	
	mineral_inventory.mineral_modified.connect(_on_mineral_modified)
		
func update():
	for child in get_children():
		child.queue_free()
	
	for m in mineral_inventory.minerals:
		var item_gui = MINERAL_INVENTORY_ITEM_GUI.instantiate()
		item_gui.set_mineral(m)
		item_gui.update(mineral_inventory.get_amount(m))
		
		mineral_to_child_map[m] = item_gui
		
		add_child(item_gui)
		
func _on_mineral_modified(mineral: Mineral, new_amount: int) -> void:
	var child = mineral_to_child_map.get(mineral)
	if child:
		child.update(new_amount)
	else:
		push_warning("Tried to modify mineral amount on gui without the mineral!")
