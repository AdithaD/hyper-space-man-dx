extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		hitbox.collide(self)
		
		health_component.take_damage(hitbox.get_damage())
