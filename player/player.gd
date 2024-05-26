extends CharacterBody2D

const SHOT = preload("res://player/shot.tscn")

signal acceleration_changed(state:bool)

@export var acceleration := 500.0
@export var max_speed := 500.0
@export var drag := 10.0

@export var cannon_points : Array[Node2D] = []

# Movement Vectors
var direction := Vector2.ZERO

var shot_count = 0

# State
var can_shoot := true
var is_mining := false

var is_accelerating = false:
	set(new_value):
		if new_value != is_accelerating:
			is_accelerating = new_value
			
			$EngineParticles1.emitting = is_accelerating
			$EngineParticles2.emitting = is_accelerating
			
			$EngineSustainSound.playing = is_accelerating
			
			if is_accelerating:
				$Camera2D.add_trauma(1.0)
				$EngineJoltSound.play()
			
			print("setting")

func _physics_process(delta):
	is_accelerating = Input.is_action_pressed("accelerate") 
	
	if is_accelerating:
		accelerate(delta)
	else:
		if not is_zero_approx(velocity.length()):
			velocity -= velocity.normalized() * drag * delta
		
		
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	
	look_at(get_global_mouse_position())
	move_and_slide()
	
func accelerate(delta):
	var dir = (get_global_mouse_position() - global_position).normalized() 
	velocity += dir * acceleration * delta
	velocity = velocity.limit_length(max_speed)

	#change_fuel(-fuel_cost)
	
func shoot():
	# select cannon point
	var cannon = cannon_points[shot_count % cannon_points.size()]
	
	# fire shot
	var new_shot = SHOT.instantiate()
	new_shot.global_position = cannon.global_position
	
	new_shot.set_target(get_global_mouse_position(), velocity)
	
	$Shots.add_child(new_shot)
	
	$CannonShotSound.play()
	$Camera2D.add_trauma(0.15)
	
	$ShotTimer.start()
	can_shoot = false
	
	shot_count += 1

func _on_shot_timer_timeout() -> void:
	can_shoot = true
