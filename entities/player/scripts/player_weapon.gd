extends Resource
class_name PlayerWeapon

enum WeaponType {
	RAY,
	HITSCAN,
	PROJECTILE
}

@export var weapon_name: String = "Weapon Name"
@export var weapon_icon: Texture2D
@export var shoot_sound: AudioStream

@export var weapon_shot_scene: PackedScene
@export var weapon_type: WeaponType
@export var is_lock_required: bool = false

@export var weapon_damage: int

# cooldown between shots of the weapon
@export var shot_cooldown: float = 1.0

@export var heat_per_shot: float = 10.0
@export var shot_trauma: float = 0.1

func instantiate_shot() -> Node:
	var shot := weapon_shot_scene.instantiate()
	shot.set_damage(weapon_damage)
	return shot
