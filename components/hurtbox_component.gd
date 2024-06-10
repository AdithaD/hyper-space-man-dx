extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

@onready var hit_particles = $HitParticles.get_children()

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		hitbox.collide(self)
		
		take_damage(hitbox.damage)

func take_damage(amount):
	health_component.take_damage(amount)

	$HurtSound.play()
	if not hit_particles.is_empty():
		for hp in hit_particles:
			if not hp.emitting:
				hp.emitting = true
				break