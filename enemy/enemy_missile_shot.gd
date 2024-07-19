extends "res://player/scripts/missile_shot.gd"

@export var destruction_partices : ParticleProcessMaterial
var parent : Enemy

func set_parent(new_parent : Enemy) -> void:
	parent = new_parent
	
func _on_health_component_died() -> void:
	parent.world.add_particles(global_position, destruction_partices)
	SoundManager.play_sound_and_free(global_position, $DeathSound.stream)

	queue_free()
