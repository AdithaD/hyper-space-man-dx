extends HurtboxComponent

@export var player : Player

@export var velocity_factor := 100

func take_damage(amount: int, type: DamageType = DamageType.FLAT, direction : Vector2 = Vector2.ZERO) -> void:	
	
	
	
	if type == DamageType.VELOCITY_SCALING:
		if not player.is_annihilation_shield_active:
			var damage := amount * floori(player.velocity.length() / velocity_factor)
			prints("scaling", floori(player.velocity.length() / velocity_factor), player.velocity.length())
			var r := player.velocity - 2 * direction.dot(player.velocity) * direction
			player.velocity = -r
			health_component.take_damage(damage)
			_play_hit_effects()
		else:
			$PassthroughSound.play()
			
	else:
		health_component.take_damage(amount)
		_play_hit_effects()



func _play_hit_effects() -> void:
	$HurtSound.play()
	if not hit_particles.is_empty():
		for hp : GPUParticles2D in hit_particles:
			if not hp.emitting:
				hp.emitting = true
				break
