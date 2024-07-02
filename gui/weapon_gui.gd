extends Control

@export var player: Player

func _ready() -> void:
	player.target_lock.lock_acquired.connect(_on_lock_acquired.unbind(1))
	player.target_lock.lock_lost.connect(_on_lock_lost)

	player.weapon_changed.connect(_on_weapon_changed)
	_on_weapon_changed(player.current_weapon)
	
func _on_weapon_changed(new_weapon: PlayerWeapon) -> void:
	$WeaponName.text = new_weapon.weapon_name
	$WeaponIconTextureRect.texture = new_weapon.weapon_icon

func _on_lock_acquired() -> void:
	%LockAcquiredLabel.show()
	%NoLockLabel.hide()

func _on_lock_lost() -> void:
	%LockAcquiredLabel.hide()
	%NoLockLabel.show()
