class_name MineAnchor
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_broken = false

var interact_area:
	get:
		return $PlayerInteractArea

func _ready() -> void:
	activate()

func activate():
	sprite.rotation_enabled = false
	sprite.play("startup")
	
	await sprite.animation_finished
	
	sprite.play("active")
	sprite.rotation_enabled = true

func _on_health_component_died() -> void:
	$DeathParticles.emitting = true
	sprite.rotation_enabled = false
	sprite.stop()
	
	is_broken = true

func _on_health_component_health_changed(_amount: int, health: int, maximum_health: int) -> void:
	%HealthBar.segments = maximum_health
	%HealthBar.value = health

func _on_player_interact_area_player_entered() -> void:
	pass # Replace with function body.

func _on_player_interact_area_player_exited() -> void:
	pass # Replace with function body.
