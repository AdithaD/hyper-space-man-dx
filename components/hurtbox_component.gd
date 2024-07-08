extends Area2D
class_name HurtboxComponent

signal hit(hitbox: HitboxComponent)

enum DamageType {
	FLAT, VELOCITY_SCALING
}

@export var health_component: HealthComponent

var active := true

@onready var hit_particles : Array = $HitParticles.get_children()

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox := area as HitboxComponent
		hitbox.collide(self)
		
		take_damage(hitbox.damage, hitbox.damage_type, area.global_position.direction_to(self.global_position))
		hit.emit(area)
		
func take_damage(amount: int, _type: DamageType = DamageType.FLAT, _normal : Vector2 = Vector2.ZERO) -> void:
	health_component.take_damage(amount)

	$HurtSound.play()
	if not hit_particles.is_empty():
		for hp : GPUParticles2D in hit_particles:
			if not hp.emitting:
				hp.emitting = true
				break
