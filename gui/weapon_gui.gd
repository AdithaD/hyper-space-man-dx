extends Control

@export var player: Player

@onready var weapon_slots = get_children()

func _ready() -> void:
	player.weapon_changed.connect(_on_weapon_changed)
	
	var index = 0 
	for weapon in player.weapons:
		weapon_slots[index].weapon = weapon
		weapon_slots[index].deselect()
		
		index += 1

	weapon_slots[0].select()
	
func _on_weapon_changed(new_weapon: PlayerWeapon):
	for slot in weapon_slots:
		slot.deselect()
		if slot.weapon == new_weapon:
			slot.select()
