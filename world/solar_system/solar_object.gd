class_name SolarObject
extends Node2D

@export var min_animation_speed: float
@export var max_animation_speed: float

@export var tooltip: String
@export var no_minerals_tooltip: String

@export var gravity = 100

#var enemy = preload("res://Assets/Enemy/_Scenes/Enemy.tscn")
var spawned_enemies = false
var solar_name
var mineral_inventory: MineralInventory
var mine_time
var mined_level

var _amount_of_enemies

var interact_area:
	get:
		return $PlayerInteractArea

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(frames: SpriteFrames, amount_of_enemies: int, p_solar_name: String, p_mineral_inventory: MineralInventory, new_scale: float=1):
	sprite.sprite_frames = frames
	sprite.set_speed_scale(randf_range(min_animation_speed, max_animation_speed))
	
	sprite.play("rotate")
	sprite.set_frame(randi() % (sprite.sprite_frames.get_frame_count("rotate")))
	
	sprite.apply_scale(Vector2(new_scale, new_scale))

	var radius = sprite.scale.x * sprite.sprite_frames.get_frame_texture("rotate", 0).get_width() / 2
	var shape = CircleShape2D.new()
	shape.radius = radius
	
	$PlayerInteractArea/CollisionShape2D.shape = shape
	
	_amount_of_enemies = amount_of_enemies
	
	solar_name = p_solar_name
	mineral_inventory = p_mineral_inventory
		
func fade(alpha):
	var start_colour = Color(1.0, 1.0, 1.0, 1.0)
	var end_colour = Color(0.35, 0.35, 0.35, alpha)
	
	var tween = get_tree().create_tween()
	tween.interpolate_property(sprite, "modulate", start_colour, end_colour, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)

func set_amount_of_enemies(amount):
	_amount_of_enemies = amount
	
func get_minerals():
	return mineral_inventory

func get_sun_name():
	return solar_name

func get_planet_name():
	return ""

func get_gravity():
	return gravity
