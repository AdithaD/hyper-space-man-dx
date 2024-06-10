extends Resource
class_name PlayerWeapon

@export var weapon_name: String = "Weapon Name"
@export var weapon_icon: Texture2D

@export var weapon_shot_scene: PackedScene
@export var is_hitscan: bool = false

@export var weapon_damage: int

# cooldown between shots of the weapon
@export var shot_cooldown = 1.0

@export var heat_per_shot = 10.0
@export var shot_trauma = 0.1

func instantiate_shot() -> Node:
	var shot = weapon_shot_scene.instantiate()
	shot.set_damage(weapon_damage)
	return shot
