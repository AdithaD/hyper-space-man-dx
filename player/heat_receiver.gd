extends Node2D
class_name HeatReceiver

var temperature : float = 0

func _physics_process(delta: float) -> void:
	var emitters := get_tree().get_nodes_in_group("heat_emitter")
	
	var total_energy : float = 0.0
	for emitter : HeatEmitter in emitters:
		total_energy += emitter.get_energy(global_position)

	temperature += total_energy * delta
	
	
