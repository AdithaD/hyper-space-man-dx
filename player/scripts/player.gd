extends CharacterBody2D
class_name Player

signal heat_changed(new_amount: int)

signal player_state_changed(anti_gravity: bool)

signal weapon_changed(current_weapon: PlayerWeapon)

signal died

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
@export var mineral_inventory: MineralInventory

@export_subgroup("Mining")
@export var mine_anchor_scene: PackedScene

# Movement Vectors
var direction := Vector2.ZERO

var shot_count = 0

# State
var is_mining := false
var is_anti_gravity_on = false
var current_weapon_index = 0
var is_dead = false

var is_overspeed:
	get:
		return velocity.length() > max_speed

var current_weapon: PlayerWeapon:
	get:
		return weapons[current_weapon_index]

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

var mine_anchor: MineAnchor = null

var mining_interactor:
	get:
		return $MiningInteractor

var is_overheated: bool:
	get:
		return not $HeatCooloffTimer.is_stopped()

@onready var heat = 0:
	set(value):
		heat = value
		heat_changed.emit(heat, heat / maximum_heat)

@onready var overspeed_timer = $OverspeedTimer

func _ready() -> void:
	mineral_inventory._init(mineral_inventory.minerals, mineral_inventory.starting_inventory)
	$HeatCooloffTimer.wait_time = maximum_heat / heat_drain_per_second

func _physics_process(delta):
	if not is_dead:
		#accelerate
		is_accelerating = Input.is_action_pressed("accelerate")
		
		if is_accelerating:
			accelerate(delta)
		else:
			if not is_zero_approx(velocity.length()):
				velocity -= velocity.normalized() * drag * delta

		# mining
		if Input.is_action_just_pressed("mine"):
			if mine_anchor == null:
				if mining_interactor.current_solar_object != null:
					deploy_mine_anchor()

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
			if overspeed_timer.is_stopped() and not is_dead:
				overspeed_timer.start()

			$Camera2D.add_trauma(1.0 * delta)
		else:
			if not overspeed_timer.is_stopped():
				overspeed_timer.stop()

		look_at(get_global_mouse_position())
		move_and_slide()
	
func die():
	$DeathParticles.emitting = true
	$Camera2D.top_level = true
	$Camera2D.global_position = global_position
	$DeathSound.play()

	is_dead = true

func accelerate(delta):
	var dir = (get_global_mouse_position() - global_position).normalized()
	var thrust = ship_engine.burn(delta, dir)
	velocity += thrust
	
func shoot():
	# select cannon point
	var cannon = cannon_points[shot_count % cannon_points.size()]

	if current_weapon.is_hitscan:
		_shoot_hitscan(current_weapon, global_position, get_global_mouse_position())
	else:
		_shoot_projectile(current_weapon, cannon.global_position, cannon.global_position + transform.x * 100)
	$CannonShotSound.play()
	$Camera2D.add_trauma(current_weapon.shot_trauma)
	
	$ShotTimer.start()

	_add_heat(current_weapon.heat_per_shot)
	shot_count += 1

func _shoot_projectile(weapon: PlayerWeapon, origin: Vector2, target: Vector2) -> void:
	var new_shot = weapon.instantiate_shot()
	new_shot.global_position = origin
	new_shot.global_rotation = global_rotation
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(target)

	if new_shot.has_method("set_inherited_velocity"):
		new_shot.set_inherited_velocity(velocity)
	
	$Shots.add_child(new_shot)

func _shoot_hitscan(weapon: PlayerWeapon, origin: Vector2, target: Vector2) -> void:
	var dss = get_world_2d().direct_space_state

	var destination = origin.direction_to(target) * 2000 + origin
	var query = PhysicsRayQueryParameters2D.create(origin, destination, 0b1000)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	
	var collision: Dictionary = dss.intersect_ray(query)

	$RayShooter.shoot_ray(origin, destination, 0.3)
	prints(origin, destination, collision)
	if collision:
		var hurtbox = collision.collider as HurtboxComponent
		hurtbox.take_damage(weapon.weapon_damage)
		print(hurtbox)

func deploy_mine_anchor():
	# instantiate
	mine_anchor = mine_anchor_scene.instantiate()
	mine_anchor.player = self
	world.add_mine_anchor(mine_anchor)
	mine_anchor.set_mine_target(mining_interactor.current_solar_object)
	mine_anchor.pickup.connect(_on_mine_anchor_pickup)

	# tween away from ship
	var tween = mine_anchor.create_tween()
	tween.tween_property(mine_anchor, "global_position", global_position + Vector2(128, 0).rotated(2 * PI * randi()), 0.5).from(global_position)

func pickup_mine_anchor():
	# get resources
	for mineral in mine_anchor.mineral_inventory.get_minerals():
		mineral_inventory.add_amount(mineral, mine_anchor.mineral_inventory.get_amount(mineral))

	mine_anchor.queue_free()
	mine_anchor = null

func _on_mine_anchor_pickup():
	pickup_mine_anchor()

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

func get_health_component() -> HealthComponent:
	return $HealthComponent

func queue_death():
	is_dead = true
	died.emit()

func _on_health_component_died() -> void:
	if not is_dead:
		queue_death()

func _on_overspeed_timer_timeout() -> void:
	if not is_dead:
		queue_death()
