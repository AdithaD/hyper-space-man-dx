extends "res://player/heat_receiver.gd"
class_name PlayerHeatReceiver
signal limit_exceeded

@export var temperature_limit : float = 100

@export var temperature_loss_rate : float = 10.0

var is_exceeded := false

func _physics_process(delta: float) -> void:
	super(delta)
	var loss := temperature_loss_rate * delta
	temperature -= loss
		
	if temperature > temperature_limit and not is_exceeded:
		is_exceeded = true
		limit_exceeded.emit()
	elif is_exceeded and temperature < temperature_limit:
		is_exceeded = false
	
	
func get_ratio() -> float:
	return min(1.0, temperature / temperature_limit)
