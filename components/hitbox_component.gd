extends Area2D
class_name HitboxComponent 

signal collided(hurtbox: HurtboxComponent)

@export var damage := 1
@export var damage_type : HurtboxComponent.DamageType

func get_damage() -> int:
	return damage

func collide(hurtbox: HurtboxComponent) -> void:
	collided.emit(hurtbox)
