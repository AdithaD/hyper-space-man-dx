extends Node2D

@export var min_animation_speed : float
@export var max_animation_speed : float

@export var tooltip : String
@export var no_minerals_tooltip : String

@export var gravity = 100

#var enemy = preload("res://Assets/Enemy/_Scenes/Enemy.tscn")
var spawned_enemies = false
var sun_name
var minerals 
var mine_time
var mined_level

var _amount_of_enemies

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(frames : SpriteFrames, amount_of_enemies: int, solar_name: String, minerals: int, new_scale: float = 1):
	
	sprite.sprite_frames = frames
	sprite.set_speed_scale(randi_range(min_animation_speed, max_animation_speed))
	
	sprite.play("rotate")
	sprite.set_frame(randi() % (sprite.sprite_frames.get_frame_count("rotate")))

	
	sprite.apply_scale(Vector2(new_scale, new_scale))
	#$TerminatorSprite.apply_scale(Vector2(scale, scale))
	#$CollisionShape2D.apply_scale(Vector2(scale, scale))
	#$EnemySpawnArea.apply_scale(Vector2(scale, scale))
	#$Path2D.apply_scale(Vector2(scale, scale))
	#$IDontFeelSoGood.apply_scale(Vector2(scale, scale))
	#$Explode.apply_scale(Vector2(scale, scale))
	
	_amount_of_enemies = amount_of_enemies 
	
	sun_name = solar_name
	self.minerals = minerals

func set_amount_of_enemies(amount):
	_amount_of_enemies = amount

#func _spawn_enemies():
	#$AudioStreamPlayer2D.play(0)
	#
	#for i in range(_amount_of_enemies):
		#var new_enemy = enemy.instantiate()
		#
		#var preset = preload("res://Assets/Enemy/Resources/Presets/Weak Enemies/Weak_enemy.tres")
		#var enemy_pos =$Path2D.curve.get_point_position(rand_range(0 , $Path2D.curve.get_point_count()))
		#
		#new_enemy.init(preset, enemy_pos, 1)
#
		#add_child(new_enemy)
				#
	#spawned_enemies = true;
	
func get_minerals():
	return minerals

func get_tooltip(mine_strength):
	if minerals > 0:
		return "Press SPACE to %s planet" % mine_strength
	else:
		return no_minerals_tooltip

func get_mine_time(mine_speed):
	return minerals/mine_speed

func mined(mine_level):
	minerals = 0

	#match mine_level:
		#8:
			#$IDontFeelSoGood.emitting = true
			#no_minerals_tooltip = "Thanos waz here"
			#fade(sprite, 0)
		#7:
			#no_minerals_tooltip = "TARGET TERMINATED"
			#$TerminatorSprite.visible = true
			#$TerminatorSprite.play()
			#
		#5, 6: 
			#$Explode.emitting = true
			#sprite.play("debris")
		#_:
	fade(sprite, 1 - 0.1 * mine_level)
		
func fade(sprite, alpha):
	var start_colour = Color(1.0, 1.0, 1.0, 1.0)
	var end_colour = Color(0.35, 0.35, 0.35, alpha)
	
	var tween = get_tree().create_tween()
	tween.interpolate_property(sprite, "modulate", start_colour, end_colour, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)

#func _on_EnemySpawnArea_area_entered(area):
	#if(area.get_name() == "Player" && not spawned_enemies):
		#_spawn_enemies()

#func _on_TerminatorSprite_animation_finished():
	#$Explode.emitting = true
	#fade($TerminatorSprite, 0)
	#$Sprite.play("debris")

func get_sun_name():
	return sun_name

func get_planet_name():
	return ""

func get_gravity():
	return gravity
