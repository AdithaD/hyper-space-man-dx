extends CharacterBody2D
class_name Player

signal heat_changed(new_amount: int)

signal player_state_changed(anti_gravity: bool)

signal weapon_changed(current_weapon: PlayerWeapon)

@export var world: World

@export_subgroup("Engine")
@export var ship_engine: ShipEngine
@export var max_speed := 500.0
@export var drag := 10.0

@export_subgroup("Weapons")
@export var weapons: Array[PlayerWeapon] = []
@export var maximum_heat: float = 100.0
@export var heat_drain_per_second = 15.0

@export var cannon_points: Array[Node2D] = []

@export_subgroup("Trade")
@export var minerals: MineralInventory

# Movement Vectors
var direction := Vector2.ZERO

var shot_count = 0

# State
var is_mining := false
var is_anti_gravity_on = false
var current_weapon_index = 0

var current_weapon: PlayerWeapon:
	get:
		return weapons[current_weapon_index]

@onready var heat = 0:
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

func _ready() -> void:
	minerals._init(minerals.minerals, minerals.starting_inventory)
	$HeatCooloffTimer.wait_time = maximum_heat / heat_drain_per_second

func _physics_process(delta):
	#accelerate
	is_accelerating = Input.is_action_pressed("accelerate")
	
	if is_accelerating:
		accelerate(delta)
	else:
		if not is_zero_approx(velocity.length()):
			velocity -= velocity.normalized() * drag * delta
		
	# shoot
	if Input.is_action_just_pressed("shoot") and not $HeatCooloffTimer.is_stopped():
		$CantShootSound.play()
		
	if Input.is_action_pressed("shoot") and $ShotTimer.is_stopped() and $HeatCooloffTimer.is_stopped():
		shoot()
	
	if Input.is_action_just_pressed("anti_gravity"):
		if ship_engine.current_fuel > 0:
			set_anti_gravity(not is_anti_gravity_on)
	
	if Input.is_action_just_pressed("cycle_weapon"):
		var new_index = (current_weapon_index + 1) % weapons.size()
		current_weapon_index = new_index
		
		$ShotTimer.wait_time = current_weapon.shot_cooldown
		weapon_changed.emit(current_weapon)
	
	# reduce heat
	if not is_zero_approx(heat):
		heat -= min(heat, heat_drain_per_second * delta)
	
	# apply gravity
	if world:
		var gravity = world.get_gravity(global_position)
		
		if not is_anti_gravity_on:
			velocity += gravity * delta
		else:
			# burn fuel equivalent to anti-gravity
			ship_engine.burn_anti_gravity(gravity * delta)
	
	# over speed camera shake
	if velocity.length() > max_speed:
		$Camera2D.add_trauma(1.0 * delta)
	
	look_at(get_global_mouse_position())
	move_and_slide()
	
func accelerate(delta):
	var dir = (get_global_mouse_position() - global_position).normalized()
	var thrust = ship_engine.burn(delta, dir)
	velocity += thrust
	
func shoot():
	# select cannon point
	var cannon = cannon_points[shot_count % cannon_points.size()]
	
	# fire shot
	var new_shot = current_weapon.instantiate_shot()
	new_shot.global_position = cannon.global_position
	new_shot.global_rotation = global_rotation
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(get_global_mouse_position(), velocity)
	
	$Shots.add_child(new_shot)
	
	$CannonShotSound.play()
	$Camera2D.add_trauma(0.15)
	
	$ShotTimer.start()
	
	_add_heat(current_weapon.heat_per_shot)
	
	shot_count += 1

func _add_heat(amount):
	heat = heat + amount
	if heat > maximum_heat:
		_cool_off()
		
func _cool_off():
	$HeatCooloffTimer.start()
	$CannonCooloffSound.play()

func set_anti_gravity(is_on: bool) -> void:
	is_anti_gravity_on = is_on
	
	if is_anti_gravity_on:
		$AntigravityOnSound.play()
	else:
		$AntigravityOffSound.play()
	
	player_state_changed.emit(is_anti_gravity_on)

func get_health_component():
	return $HealthComponent
