extends Control

@export var player: Player

@onready var weapon_slots = $WeaponGUI.get_children()

func _ready() -> void:
	player.target_lock.lock_acquired.connect(_on_lock_acquired.unbind(1))
	player.target_lock.lock_lost.connect(_on_lock_lost)

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

func _on_lock_acquired():
	%LockAcquiredLabel.show()
	%NoLockLabel.hide()

func _on_lock_lost():
	%LockAcquiredLabel.hide()
	%NoLockLabel.show()
