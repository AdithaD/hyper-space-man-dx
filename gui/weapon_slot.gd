extends Control

@export var weapon: PlayerWeapon: set = set_weapon

var selected = false

func _ready() -> void:
	if weapon:
		set_weapon(weapon)
	
func set_weapon(value: PlayerWeapon) -> void:
	weapon = value
	$TextureRect.texture = weapon.weapon_icon

func select() -> void:
	selected = true
	$TextureRect/ColorRect.hide()
	
func deselect() -> void:
	selected = false
	$TextureRect/ColorRect.show()
