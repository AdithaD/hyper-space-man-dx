extends Node2D
class_name World

@export var gravity_cutoff = 1000
@export var gravitational_constant = 10000000
@export var maximum_gravity = 40.0

func get_gravity(origin: Vector2) -> Vector2:
	return get_tree().get_nodes_in_group("gravitator") \
		.filter(func(node): return node.global_position.distance_to(origin) < gravity_cutoff) \
		.map(func(node): return _newtonian_gravity(origin, node.global_position, node.get_gravity())) \
		.reduce(func(acc, x): return acc + x, Vector2.ZERO) \
		.limit_length(maximum_gravity)
		
func _newtonian_gravity(origin: Vector2, gravitator_position: Vector2, strength: float) -> Vector2:
	return origin.direction_to(gravitator_position) * ((gravitational_constant * strength) / max(10, origin.distance_squared_to(gravitator_position)))

func add_mine_anchor(mine_anchor: MineAnchor) -> void:
	add_child(mine_anchor)

func configure_player(player: Player) -> void:
	$SolarSystemSpawner.solar_system_spawned.connect(player.mining_interactor._on_solar_system_spawner_solar_system_spawned)
	
func start():
	$SolarSystemSpawner.start_spawn()
