class_name SolarSystem
extends Node2D

@export_subgroup("Planet")
@export var planet_scene: PackedScene
@export var planet_sprites: Array[SpriteFrames]
@export var planet_width: int

@export var planet_min_scale: float
@export var planet_max_scale: float

@export var planet_randomness: float
@export var planet_minerals_mean: float
@export var planet_minerals_randomness: float

@export_subgroup("Sun")
@export var sun_scene: PackedScene
@export var sun_sprites: Array[SpriteFrames]
@export var sun_width: int

@export var sun_min_scale: float
@export var sun_max_scale: float

@export var sun_minerals_mean: float
@export var sun_minerals_randomness: float

@export_subgroup("Enemies")
@export var enemy_amount_curve: Curve
@export var enemy_scene: PackedScene

@export_subgroup("Space Station")
@export var space_station_scenes: Array[PackedScene]

var spread : float

var sun_name : String

var sun_to_planet : float
var sun : SolarObject

var planet_grid := {}

var solar_objects : Array[SolarObject]:
	get:
		var arr: Array[SolarObject] = []
		arr.assign(get_children().filter(func(x: Node) -> bool: return x is SolarObject))

		return arr
		
var space_stations : Array[SpaceStation]:
	get:
		var arr: Array[SpaceStation] = []
		arr.assign(get_children().filter(func(x: Node) -> bool: return x is SpaceStation))

		return arr

func init(number_of_planets : int, p_spread : float, p_sun_name : String) -> void:
	spread = p_spread
	sun_name = p_sun_name

	sun_to_planet = sun_width / (planet_width + (planet_width * (planet_randomness / 2)))
	for i in range( - ceil(sun_to_planet / 2), ceil(sun_to_planet / 2)):
		for j in range( - ceil(sun_to_planet / 2), ceil(sun_to_planet / 2)):
			planet_grid[Vector2(i, j)] = true
	spawn_sun()
	
	spawn_space_station(sun.global_position)
	
	$AsteroidBelt._generate()
		
	for x in range(0, number_of_planets):
		spawn_planet()
	
	var amount_of_enemies := enemy_amount_curve.sample(randf())
	var group := EnemyGroup.new()
	group.home_solar_system = self
	
	$Enemies.add_child(group)
	
	for i in range(amount_of_enemies):
		spawn_enemy(group, Vector2(i * 64, 0))
		
func spawn_enemy(group: EnemyGroup, local_position: Vector2) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.group = group

	enemy.global_position = global_position + local_position
	group.add_child(enemy)

func spawn_space_station(orbit_origin: Vector2) -> void:
	var spawn_pos := Vector2(randf_range( - 1 * spread, spread), randf_range( - 1 * spread, spread))
	var spawn_grid_pos := (spawn_pos / ((planet_width) + (planet_width * planet_randomness))).floor()
	if not planet_grid.has(spawn_grid_pos):
		
		planet_grid[spawn_grid_pos] = true
		
		var space_station : SpaceStation = space_station_scenes.pick_random().instantiate()
		add_child(space_station)
		#space_station.init(sun_name)
		space_station.orbit_origin = orbit_origin
		print(orbit_origin)
		space_station.position = spawn_grid_pos * (planet_width + (planet_width * (planet_randomness)))
		space_station.position += Vector2(_get_random(planet_width, planet_randomness), _get_random(planet_width, planet_randomness))

const PLANET_MINERAL_FACTORY = preload ("res://minerals/planet_mineral_factory.tres")
func spawn_planet() -> void:
	var spawn_pos := Vector2(randf_range( - 1 * spread, spread), randf_range( - 1 * spread, spread))
	var spawn_grid_pos := (spawn_pos / ((planet_width) + (planet_width * planet_randomness))).floor()
	if not planet_grid.has(spawn_grid_pos):
		
		planet_grid[spawn_grid_pos] = true
		
		var planet : SolarObject = planet_scene.instantiate()
		add_child(planet)
		var planet_scale := randf_range(planet_min_scale, planet_max_scale)
		var sprite := planet_sprites[randi() %len(planet_sprites)]
		
		var mineral_weight := randf()
		var minerals := PLANET_MINERAL_FACTORY.generate_mineral_inventory(mineral_weight)
		
		planet.init(sprite, sun_name, minerals, planet_scale)
		planet.sun_position = sun.position
		planet.position = spawn_grid_pos * (planet_width + (planet_width * planet_randomness))
		planet.position += Vector2(_get_random(planet_width, planet_randomness), _get_random(planet_width, planet_randomness))
		
const SUN_MINERAL_FACTORY = preload ("res://minerals/sun_mineral_factory.tres")
func spawn_sun() -> void:
	sun = sun_scene.instantiate() as SolarObject
	add_child(sun)
	var sun_scale := randf_range(sun_min_scale, sun_max_scale)
	var sprite := sun_sprites[randi() %len(sun_sprites)]
	var mineral_weight := randf()
	var minerals := SUN_MINERAL_FACTORY.generate_mineral_inventory(mineral_weight)
	sun.init(sprite, sun_name, minerals, sun_scale)
	
	sun.position = Vector2(0, 0)
			
func _get_random(mean : float, randomness : float) -> float:
	return randf_range( - randomness, randomness) * mean

func _get_random_from_mean(mean : float, randomness : float) -> float:
	return _get_random(mean, randomness) + mean
