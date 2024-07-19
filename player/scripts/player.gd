extends CharacterBody2D
class_name Player
signal heat_changed(new_amount: int)

signal player_state_changed(anti_gravity: bool)

signal weapon_changed(current_weapon: PlayerWeapon)

signal died

signal upgraded

@export var world: World
@export var upgrades: Array[TieredUpgrade]

@export_subgroup("Engine")
@export var ship_engine: ShipEngine
@export var drag := 10.0
@export var burst_impulse := 600.0

@export_subgroup("Weapons")
@export var weapons: Array[PlayerWeapon] = []
@export var maximum_heat: float = 100.0
@export var heat_drain_per_second : float = 15.0

@export var cannon_points: Array[Node2D] = []

@export_subgroup("Trade")
@export var mineral_inventory: MineralInventory

@export_subgroup("Mining")
@export var mining_drone_scene: PackedScene

# State
# Movement Vectors
var direction := Vector2.ZERO

var shot_count : int = 0

var is_mining := false
var is_anti_gravity_on := false
var current_weapon_index := 0
var is_dead := false
var has_control := true

var max_speed := 500.0

var is_annihilation_shield_active := false:
	set(value):
		# disable environment collisions
		collision_mask = collision_mask & 0b0 if value else collision_mask | 0b1
		is_annihilation_shield_active = value

var upgrade_tier: Dictionary

var is_overspeed: bool:
	get:
		return velocity.length() > max_speed

var current_weapon: PlayerWeapon:
	get:
		return weapons[current_weapon_index]

var is_accelerating := false:
	set(new_value):
		if new_value != is_accelerating:
			is_accelerating = new_value
			
			for ep in engine_particles:
				ep.emitting = is_accelerating
			
			engine_sustain_sound.playing = is_accelerating
			
			if is_accelerating:
				camera_2d.add_trauma(1.0)
				engine_jolt_sound.play()

var maximum_drone_amount : int = 1
var drone_harvest_rate : int = 100
var drone_storage_amount : int = 2000

# needs to be an array
var mining_drones: Array[MiningDrone] = []

var is_overheated: bool:
	get:
		return not heat_cooloff_timer.is_stopped()

var heat := 0.0:
	set(value):
		heat = value
		heat_changed.emit(heat, heat / maximum_heat)
		
#region onready vars
@onready var camera_2d: Camera2D = $Camera2D

@onready var engine_jolt_sound: AudioStreamPlayer2D = $Sounds/EngineJoltSound
@onready var death_sound: AudioStreamPlayer2D = $Sounds/DeathSound
@onready var antigravity_on_sound: AudioStreamPlayer2D = $Sounds/AntigravityOnSound
@onready var antigravity_off_sound: AudioStreamPlayer2D = $Sounds/AntigravityOffSound
@onready var engine_sustain_sound: AudioStreamPlayer2D = $Sounds/EngineSustainSound
@onready var cannon_cooloff_sound: AudioStreamPlayer2D = $Sounds/CannonCooloffSound
@onready var weapon_shot_sound: AudioStreamPlayer2D = $Sounds/WeaponShotSound
@onready var cant_shoot_sound: AudioStreamPlayer2D = $Sounds/CantShootSound
@onready var pickup_sound: AudioStreamPlayer2D = $Sounds/PickupSound
@onready var switch_weapon_sound: AudioStreamPlayer = $Sounds/SwitchWeaponSound

@onready var overspeed_timer: Timer = $OverspeedTimer
@onready var heat_cooloff_timer: Timer = $HeatCooloffTimer
@onready var shot_timer: Timer = $ShotTimer

@onready var target_lock : TargetLockAcquirer = $TargetLockAcquirer
@onready var mining_interactor: MiningInteractor = $MiningInteractor
@onready var health_component: HealthComponent = $HealthComponent
@onready var burst_manager: BurstManager = $BurstManager
@onready var heat_receiver: PlayerHeatReceiver = $HeatReceiver

@onready var engine_particles : Array[GPUParticles2D] = [$Particles/EngineParticles1, $Particles/EngineParticles2]
@onready var death_particles: GPUParticles2D = $Particles/DeathParticles
@onready var ray_shooter: Node2D = $RayShooter

@onready var shot_parent: Node = $ShotParent
#endregion

func _ready() -> void:
	ship_engine.reset_state()
	
	for upgrade in upgrades:
		apply_upgrade(upgrade, false)

	mineral_inventory._init(mineral_inventory.starting_inventory)
	heat_cooloff_timer.wait_time = maximum_heat / heat_drain_per_second
	
	_set_weapon(current_weapon)
	
	mineral_inventory.mineral_modified.connect(pickup_sound.play.unbind(2))

func apply_impulse(impulse: Vector2) -> void:
	velocity += transform.basis_xform(impulse)

func _physics_process(delta: float) -> void:
	if not is_dead and has_control:
		burst_manager.notify(Input.is_action_just_pressed("burst_left"), Input.is_action_just_pressed("burst_right"))
		#accelerate
		is_accelerating = Input.is_action_pressed("accelerate")
		
		if is_accelerating:
			accelerate(delta)
		else:
			if not is_zero_approx(velocity.length()) and velocity.length() < 100:
				velocity -= velocity.normalized() * drag * delta

		# shoot
		if Input.is_action_just_pressed("shoot") and not heat_cooloff_timer.is_stopped():
			cant_shoot_sound.play()
			
		if Input.is_action_pressed("shoot") and shot_timer.is_stopped() and heat_cooloff_timer.is_stopped():
			shoot()

		# reduce heat
		if not is_zero_approx(heat):
			heat -= min(heat, heat_drain_per_second * delta)

		# over speed camera shake
		if velocity.length() > max_speed:
			if overspeed_timer.is_stopped() and not is_dead:
				overspeed_timer.start()

			camera_2d.add_trauma(1.0 * delta)
		else:
			if not overspeed_timer.is_stopped():
				overspeed_timer.stop()

		look_at(get_global_mouse_position())
		
	velocity = velocity.limit_length(300000)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if has_control:		
		if event.is_action_pressed("mine"):
			if mining_drones.size() < maximum_drone_amount:
				if mining_interactor.current_solar_object != null:
					_deploy_mining_drone()

		if event.is_action_pressed("anti_gravity"):
			if ship_engine.current_fuel > 0:
				set_anti_gravity(not is_anti_gravity_on)
		
		if Input.is_action_pressed("cycle_weapon"):
			var new_index := (current_weapon_index + 1) % weapons.size()
			current_weapon_index = new_index
			switch_to_weapon(current_weapon)

func _set_weapon(weapon: PlayerWeapon) -> void:
	shot_timer.wait_time = weapon.shot_cooldown
	weapon_shot_sound.stream = weapon.shoot_sound
	#$TargetLockAcquirer.set_enabled(weapon.is_lock_required)
	weapon_changed.emit(weapon)
	
func switch_to_weapon(weapon: PlayerWeapon) -> void:
	_set_weapon(weapon)
	switch_weapon_sound.play()

func die() -> void:
	death_particles.emitting = true
	#$Camera2D.top_level = true
	#$Camera2D.global_position = global_position
	death_sound.play()

	is_dead = true

func accelerate(delta: float) -> void:
	var dir := (get_global_mouse_position() - global_position).normalized()
	var thrust := ship_engine.burn(delta, dir)
	velocity += thrust
	
func shoot() -> void:
	# select cannon point
	var cannon := cannon_points[shot_count % cannon_points.size()]

	# weapons requiring lock needs a lock target
	if current_weapon.is_lock_required and target_lock.get_current_target() == null:
		return

	if current_weapon.is_hitscan:
		_shoot_hitscan(current_weapon, global_position, get_global_mouse_position())
	else:
		_shoot_projectile(current_weapon, cannon.global_position, cannon.global_position + transform.x * 100)
	weapon_shot_sound.play()
	camera_2d.add_trauma(current_weapon.shot_trauma)
	
	shot_timer.start()

	_add_heat(current_weapon.heat_per_shot)
	shot_count += 1

func _shoot_projectile(weapon: PlayerWeapon, origin: Vector2, target: Vector2) -> void:
	var new_shot := weapon.instantiate_shot()
	new_shot.global_position = origin
	new_shot.global_rotation = global_rotation
	
#	new_shot.player = self
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(target)

	if new_shot.has_method("set_inherited_velocity"):
		new_shot.set_inherited_velocity(velocity)
	
	shot_parent.add_child(new_shot)

func _shoot_hitscan(weapon: PlayerWeapon, origin: Vector2, target: Vector2) -> void:
	var dss := get_world_2d().direct_space_state

	var destination := origin.direction_to(target) * 2000 + origin
	var query := PhysicsRayQueryParameters2D.create(origin, destination, 0b1000)
	query.collide_with_bodies = false
	query.collide_with_areas = true
	
	var collision: Dictionary = dss.intersect_ray(query)

	ray_shooter.shoot_ray(origin, destination)
	if collision:
		var hurtbox := collision.collider as HurtboxComponent
		hurtbox.take_damage(weapon.weapon_damage)
		print(hurtbox)

func _deploy_mining_drone() -> void:
	# instantiate
	var mining_drone : MiningDrone = mining_drone_scene.instantiate()
	
	# apply upgrades
	mining_drone.harvest_rate = drone_harvest_rate
	mining_drone.maximum_storage = drone_storage_amount

	mining_drone.player = self
	world.add_mining_drone(mining_drone)
	
	var mine_target := mining_interactor.current_solar_object
	mining_drone.set_mine_target(mine_target)
	mining_drone.pickup.connect(_pickup_mining_drone.bind(mining_drone))

	# tween away from ship
	var tween := mining_drone.create_tween()
	var vec_to_so := global_position.direction_to(mine_target.global_position)
	var dir := Vector2(128, 0).rotated(vec_to_so.angle())
	tween.tween_property(mining_drone, "global_position", global_position + dir, 0.5).from(global_position)
	
	mining_drones.append(mining_drone)

func _pickup_mining_drone(mining_drone: MiningDrone) -> void:
	# get resources
	for mineral : Mineral in mining_drone.mineral_inventory.get_minerals():
		mineral_inventory.add_amount(mineral, mining_drone.mineral_inventory.get_amount(mineral))

	mining_drones.erase(mining_drone)
	mining_drone.queue_free()
	mining_drone = null

func apply_upgrade(upgrade: TieredUpgrade, level_up := true) -> void:
	if upgrade.get_max_tier() != get_tier(upgrade):
		if level_up:
			mineral_inventory.remove_subset(upgrade.get_tier_cost(upgrade_tier.get_or_add(upgrade, 0)))
			upgrade_tier[upgrade] = get_tier(upgrade) + 1

		var value := upgrade.get_tier_value(get_tier(upgrade))
		match upgrade.upgrade_id:
			&"max_speed":
				max_speed = value
			&"fuel_capacity":
				ship_engine.fuel_capacity = value
			&"mass_flow":
				ship_engine.mass_flow_rate = value
			&"exhaust_velocity":
				ship_engine.exhaust_velocity = value
			&"max_heat":
				maximum_heat = value
			&"cooling_speed":
				heat_drain_per_second = value
			&"drone_amount":
				maximum_drone_amount = int(value)
			&"harvest_rate":
				drone_harvest_rate = int(value)
			&"drone_storage":
				drone_storage_amount = int(value)
			&"hull":
				health_component.maximum_health = int(value)
			&"annihilation_shield":
				is_annihilation_shield_active = bool(value)
			&"temp_shielding":
				heat_receiver.temperature_limit = int(value)
			&"temp_radiators":
				heat_receiver.temperature_loss_rate = float(value)
			&"burst_charges":
				burst_manager.set_burst_amount(int(value))
		upgraded.emit()

func can_upgrade(upgrade: TieredUpgrade) -> bool:
	return upgrade.get_max_tier() > get_tier(upgrade) and mineral_inventory.is_superset(upgrade.get_tier_cost(get_tier(upgrade)))

func get_tier(upgrade: TieredUpgrade) -> int:
	return upgrade_tier.get_or_add(upgrade, 0)

func _add_heat(amount: float) -> void:
	heat = heat + amount
	if heat > maximum_heat:
		_cool_off()
		
func _cool_off() -> void:
	heat_cooloff_timer.start()
	cannon_cooloff_sound.play()

func set_anti_gravity(is_on: bool) -> void:
	is_anti_gravity_on = is_on
	
	if is_anti_gravity_on:
		antigravity_on_sound.play()
	else:
		antigravity_off_sound.play()
	
	player_state_changed.emit(is_anti_gravity_on)

func queue_death() -> void:
	is_dead = true
	died.emit()

func _on_health_component_died() -> void:
	if not is_dead:
		queue_death()

func _on_overspeed_timer_timeout() -> void:
	if not is_dead:
		queue_death()
