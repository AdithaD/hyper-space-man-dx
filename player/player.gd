extends CharacterBody2D

const SHOT = preload("res://player/shot.tscn")

signal acceleration_changed(state:bool)

signal fuel_changed(new_amount: int)
signal heat_changed(new_amount: int)

@export var acceleration := 500.0
@export var max_speed := 500.0
@export var drag := 10.0

@export var cannon_points : Array[Node2D] = []

@export var maximum_fuel : float = 100.0
@export var fuel_cost_per_second = 1.0

@export var maximum_heat : float = 100.0
@export var heat_drain_per_second = 15.0
@export var heat_per_shot = 10.0

# Movement Vectors
var direction := Vector2.ZERO

var shot_count = 0

# State
var is_mining := false

@onready var current_fuel = maximum_fuel:
	set(value):
		current_fuel = value
		fuel_changed.emit(current_fuel, current_fuel / maximum_fuel)
		
@onready var heat = 100:
	set(value):
		heat = value
		heat_changed.emit(heat, heat / maximum_heat)

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

func _ready() -> void:
	$HeatCooloffTimer.wait_time = maximum_heat / heat_drain_per_second

func _physics_process(delta):
	is_accelerating = Input.is_action_pressed("accelerate") 
	
	if is_accelerating:
		accelerate(delta)
	else:
		if not is_zero_approx(velocity.length()):
			velocity -= velocity.normalized() * drag * delta
		
		
	if Input.is_action_pressed("shoot") and $ShotTimer.is_stopped() and $HeatCooloffTimer.is_stopped():
		shoot()
	
	if not is_zero_approx(heat):
		heat -= min(heat, heat_drain_per_second * delta)
	
	look_at(get_global_mouse_position())
	move_and_slide()
	
func accelerate(delta):
	var dir = (get_global_mouse_position() - global_position).normalized() 
	velocity += dir * acceleration * delta
	velocity = velocity.limit_length(max_speed)

	current_fuel -= fuel_cost_per_second * delta
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
	
	_add_heat(heat_per_shot)
	
	shot_count += 1

func _add_heat(amount):
	heat = heat + amount
	if heat > maximum_heat:
		_cool_off()
		
func _cool_off():
	$HeatCooloffTimer.start()
	$CannonCooloffSound.play()
