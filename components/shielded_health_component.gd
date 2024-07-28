extends HealthComponent

signal shield_strength_changed(shield_strength: int)

@export var max_shield_strength: int = 50
@export var regen_rate := 25

@onready var _shield_strength: float = max_shield_strength
@onready var regen_timer: Timer = $ShieldRegenDelayTimer

func _physics_process(delta: float) -> void:
	if _shield_strength < max_shield_strength and regen_timer.is_stopped():
		_shield_strength = move_toward(_shield_strength, max_shield_strength, regen_rate * delta)

		shield_strength_changed.emit(get_shield_ratio())

func take_damage(amount: int) -> void:
	var damage_to_shield := mini(amount, ceili(_shield_strength))

	_shield_strength = move_toward(_shield_strength, 0, damage_to_shield)
	shield_strength_changed.emit(get_shield_ratio())

	if damage_to_shield > 0:
		regen_timer.start()

	super(amount - damage_to_shield)
	
func get_shield_ratio() -> float:
	return min(1.0, _shield_strength / max_shield_strength)