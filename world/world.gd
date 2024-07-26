extends Node2D
class_name World

signal mining_drone_created(mining_drone: MiningDrone)

@export var gravity_cutoff: int = 1000
@export var gravitational_constant: float = 10000000
@export var maximum_gravity: float = 40.0

@export var item_pickup_scene: PackedScene
@export var player: Player
@export var player_speed_spawn_cutoff := 100000

@export_subgroup("Registry")
@export var minerals: Array[Mineral] = []

@onready var solar_system_spawner: SolarSystemSpawner = %SolarSystemSpawner

func _process(delta: float) -> void:
	solar_system_spawner.active = player.velocity.length() < player_speed_spawn_cutoff

func get_gravity(origin: Vector2) -> Vector2:
	return get_tree().get_nodes_in_group("gravitator") \
		.filter(func(node: Node2D) -> bool: return node.global_position.distance_to(origin) < gravity_cutoff) \
		.map(func(node: Node2D) -> Vector2: return _newtonian_gravity(origin, node.global_position, node.get_gravity())) \
		.reduce(func(acc: Vector2, x: Vector2) -> Vector2: return acc + x, Vector2.ZERO) \
		.limit_length(maximum_gravity)
		
func _newtonian_gravity(origin: Vector2, gravitator_position: Vector2, strength: float) -> Vector2:
	return origin.direction_to(gravitator_position) * ((gravitational_constant * strength) / max(10, origin.distance_squared_to(gravitator_position)))

func add_mining_drone(mining_drone: MiningDrone) -> void:
	add_child(mining_drone)
	mining_drone_created.emit(mining_drone)

func spawn_mineral_pickup(location: Vector2, mineral: Mineral, amount: int) -> void:
	var instance := item_pickup_scene.instantiate()
	
	instance.global_position = location
	instance.mineral = mineral
	instance.amount = amount
	instance.world = self
	
	call_deferred("add_child", instance)

func add_particles(location: Vector2, destruction_partices: ParticleProcessMaterial) -> void:
	var particles := GPUParticles2D.new()
	
	particles.global_position = location
	particles.process_material = destruction_partices
	particles.one_shot = true
	
	add_child(particles)
	particles.emitting = true
	
	particles.finished.connect(particles.queue_free)

func configure_player(player: Player) -> void:
	$SolarSystemSpawner.solar_system_spawned.connect(player.mining_interactor._on_solar_system_spawner_solar_system_spawned)

func start() -> void:
	$SolarSystemSpawner.start_spawn()
