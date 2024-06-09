extends Resource
class_name PlayerWeapon

@export var weapon_name : String = "Weapon Name"
@export var weapon_icon : Texture2D

@export var weapon_shot_scene : PackedScene

# cooldown between shots of the weapon
@export var shot_cooldown = 1.0

@export var heat_per_shot = 10.0

func instantiate_shot() -> Node:
	var shot = weapon_shot_scene.instantiate()
	return shot
