extends Area2D
class_name HitboxComponent 

signal collided(hurtbox: HurtboxComponent)

@export var damage := 1.0

func get_damage():
	return damage

func collide(hurtbox: HurtboxComponent):
	collided.emit(hurtbox)
