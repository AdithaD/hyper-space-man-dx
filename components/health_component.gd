extends Node
class_name HealthComponent

signal health_changed(amount: int, health: int, maximum_health: int)

signal died

@export var maximum_health = 100

@onready var current_health : int = maximum_health

func take_damage(amount: int):
	current_health = max(0, current_health - abs(amount))
	health_changed.emit(amount, current_health, maximum_health)
	
	if current_health == 0:
		_die()

func heal(amount: int):
	current_health = min(maximum_health, current_health + amount)
	health_changed.emit(amount, current_health, maximum_health)

func _die():
	died.emit()
