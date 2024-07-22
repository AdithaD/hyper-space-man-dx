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
@export var planet_mineral_factory: MineralInventoryFactory

@export_subgroup("Sun")
@export var sun_scene: PackedScene
@export var sun_sprites: Array[SpriteFrames]
@export var sun_width: int

@export var sun_min_scale: float
@export var sun_max_scale: float

@export var sun_minerals_mean: float
@export var sun_minerals_randomness: float

@export var sun_mineral_factory: MineralInventoryFactory

@export_subgroup("Space Station")
@export var space_station_scenes: Array[PackedScene]

var spread: float

var sun_name: String

var sun_to_planet: float
var sun: SolarObject

var planet_grid := {}

var solar_objects: Array[SolarObject]:
	get:
		var arr: Array[SolarObject] = []
		arr.assign(get_children().filter(func(x: Node) -> bool: return x is SolarObject))

		return arr
		
var space_stations: Array[SpaceStation]:
	get:
		var arr: Array[SpaceStation] = []
		arr.assign(get_children().filter(func(x: Node) -> bool: return x is SpaceStation))

		return arr

var world: World
var size: int

@onready var player_interact_area: PlayerInteractArea = $PlayerInteractArea
@onready var asteroid_belt: Node2D = $AsteroidBelt

func init(p_world: World, p_size: int, number_of_planets: int, p_spread: float, p_sun_name: String) -> void:
	world = p_world
	
	size = p_size
	$PlayerInteractArea/CollisionShape2D.shape.set_deferred("radius", size)
	
	spread = p_spread
	sun_name = p_sun_name

	sun_to_planet = sun_width / (planet_width + (planet_width * (planet_randomness / 2)))
	for i in range( - ceil(sun_to_planet / 2), ceil(sun_to_planet / 2)):
		for j in range( - ceil(sun_to_planet / 2), ceil(sun_to_planet / 2)):
			planet_grid[Vector2(i, j)] = true
	spawn_sun()
	
	spawn_space_station(sun.global_position)
	
	asteroid_belt.min_radius = spread * 1.2
	asteroid_belt.max_radius = spread * 1.5
	
	$AsteroidBelt._generate()
		
	for x in range(0, number_of_planets):
		spawn_planet()

func spawn_space_station(orbit_origin: Vector2) -> void:
	var spawn_pos := Vector2(randf_range( - 1 * spread, spread), randf_range( - 1 * spread, spread))
	var spawn_grid_pos := (spawn_pos / ((planet_width) + (planet_width * planet_randomness))).floor()
	if not planet_grid.has(spawn_grid_pos):
		
		planet_grid[spawn_grid_pos] = true
		
		var space_station: SpaceStation = space_station_scenes.pick_random().instantiate()
		add_child(space_station)
		#space_station.init(sun_name)
		space_station.orbit_origin = orbit_origin
		print(orbit_origin)
		space_station.position = spawn_grid_pos * (planet_width + (planet_width * (planet_randomness)))
		space_station.position += Vector2(_get_random(planet_width, planet_randomness), _get_random(planet_width, planet_randomness))

func spawn_planet() -> void:
	var spawn_pos := Vector2(randf_range( - 1 * spread, spread), randf_range( - 1 * spread, spread))
	var spawn_grid_pos := (spawn_pos / ((planet_width) + (planet_width * planet_randomness))).floor()
	if not planet_grid.has(spawn_grid_pos):
		
		planet_grid[spawn_grid_pos] = true
		
		var planet: SolarObject = planet_scene.instantiate()
		add_child(planet)
		var planet_scale := randf_range(planet_min_scale, planet_max_scale)
		var sprite := planet_sprites[randi() %len(planet_sprites)]
		
		var mineral_weight := randf()
		var minerals := planet_mineral_factory.generate_mineral_inventory(mineral_weight)
		
		planet.init(sprite, sun_name, minerals, planet_scale)
		planet.sun_position = sun.position
		planet.position = spawn_grid_pos * (planet_width + (planet_width * planet_randomness))
		planet.position += Vector2(_get_random(planet_width, planet_randomness), _get_random(planet_width, planet_randomness))
		
func spawn_sun() -> void:
	sun = sun_scene.instantiate() as SolarObject
	add_child(sun)
	var sun_scale := randf_range(sun_min_scale, sun_max_scale)
	var sprite := sun_sprites[randi() %len(sun_sprites)]
	var mineral_weight := randf()
	var minerals := sun_mineral_factory.generate_mineral_inventory(mineral_weight)
	sun.init(sprite, sun_name, minerals, sun_scale)
	
	sun.position = Vector2(0, 0)
			
func _get_random(mean: float, randomness: float) -> float:
	return randf_range( - randomness, randomness) * mean

func _get_random_from_mean(mean: float, randomness: float) -> float:
	return _get_random(mean, randomness) + mean
