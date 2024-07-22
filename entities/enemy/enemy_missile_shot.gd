extends MissileShot

@export var destruction_partices: ParticleProcessMaterial
	
func _on_health_component_died() -> void:
	shot_owner.world.add_particles(global_position, destruction_partices)
	SoundManager.play_sound_and_free(global_position, $DeathSound.stream)

	queue_free()
