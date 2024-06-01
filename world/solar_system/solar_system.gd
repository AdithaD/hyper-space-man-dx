extends Node2D
@export_subgroup("Planet")
@export var planet_scene : PackedScene
@export var planet_sprites: Array[SpriteFrames]
@export var planet_width : int

@export var planet_min_scale : float
@export var planet_max_scale : float

@export var planet_randomness : float
@export var planet_minerals_mean : float
@export var planet_minerals_randomness : float

@export var planet_enemies_mean : float
@export var planet_enemies_randomness : float

@export_subgroup("Sun")
@export var sun_scene : PackedScene
@export var sun_sprites : Array[SpriteFrames]
@export var sun_width : int

@export var sun_min_scale : float
@export var sun_max_scale : float

@export var sun_minerals_mean : float
@export var sun_minerals_randomness : float

@export var sun_enemies_mean : float
@export var sun_enemies_randomness : float

#@export var fuel_station_scene : PackedScene

var spread

var sun_name
var planet_names = "abcdefghijklmnopqrstuvqxyz"

var sun_to_planet
var sun

var planet_grid = {}

func init(n, spread, sun_name):
	self.spread = spread
	self.sun_name = sun_name
	#comment grid code out if sprites format changes or this spefic code no longer applies to format
	#planet_width = load(planet_sprites[0][0]).get_width() * planet_max
	#*1.5 for clear radius around sun
	#sun_width = (load(sun_sprites[0][0]).get_width() * sun_max) * 2
	sun_to_planet = sun_width / (planet_width + (planet_width * (planet_randomness/2)))
	for i in range(-ceil(sun_to_planet/2), ceil(sun_to_planet/2)):
		for j in range(-ceil(sun_to_planet/2), ceil(sun_to_planet/2)):
			planet_grid[Vector2(i, j)] = true
	spawn_sun()
	
	#spawn_fuel_station()
		
	for x in range(0, n):
		spawn_planet(x)

#func init(n, spread, sun_sprites, planet_sprites, sun_name):
	#self.spread = spread
	#self.sun_sprites = sun_sprites
	#self.planet_sprites = planet_sprites
	#self.sun_name = sun_name
	##comment grid code out if sprites format changes or this spefic code no longer applies to format
	#planet_width = load(planet_sprites[0][0]).get_width() * planet_max
	##*1.5 for clear radius around sun
	#sun_width = (load(sun_sprites[0][0]).get_width() * sun_max) * 2
	#sun_to_planet = sun_width/(planet_width + (planet_width * (planet_randomness/2)))
	#for i in range(-ceil(sun_to_planet/2), ceil(sun_to_planet/2)):
		#for j in range(-ceil(sun_to_planet/2), ceil(sun_to_planet/2)):
			#planet_grid[Vector2(i, j)] = true
	#spawn_sun()
	#
	##spawn_fuel_station()
		#
	#for x in range(0, n):
		#spawn_planet(x)
		
#func spawn_fuel_station():
	#var spawn_pos = Vector2(randf_range(-1 * spread, spread), randf_range(-1 * spread, spread))
	#var spawn_grid_pos = (spawn_pos/((planet_width) + (planet_width * planet_randomness))).floor()
	#if not planet_grid.has(spawn_grid_pos):
		#
		#planet_grid[spawn_grid_pos] = true
		#
		#var fuel_station = fuel_station_scene.instantiate()
		#add_child(fuel_station)
		#fuel_station.init(sun_name)
#
		#fuel_station.position = spawn_grid_pos * (planet_width + (planet_width * (planet_randomness)))
		#fuel_station.position += Vector2(get_random(planet_width, planet_randomness), get_random(planet_width, planet_randomness))
			
func spawn_planet(n):
	var spawn_pos = Vector2(randf_range(-1 * spread, spread), randf_range(-1 * spread, spread))
	var spawn_grid_pos = (spawn_pos / ((planet_width) + (planet_width * planet_randomness))).floor()
	if not planet_grid.has(spawn_grid_pos):
		
		planet_grid[spawn_grid_pos] = true
		
		var planet = planet_scene.instantiate()
		add_child(planet)
		var planet_scale = randf_range(planet_min_scale, planet_max_scale)
		var sprite = planet_sprites[randi()%len(planet_sprites)]
		
		var amount_of_enemies = int(get_random_from_mean(planet_enemies_mean, planet_enemies_randomness))
		var amount_of_minerals = int(get_random_from_mean(planet_minerals_mean, planet_minerals_randomness))
		
		planet.init(sprite, amount_of_enemies, sun_name, amount_of_minerals, planet_scale)
		planet.sun_position = sun.position
		planet.position = spawn_grid_pos * (planet_width + (planet_width * planet_randomness))
		planet.position += Vector2(get_random(planet_width, planet_randomness), get_random(planet_width, planet_randomness))
		planet.planet_name = planet_names[n]

func spawn_sun():
	sun = sun_scene.instantiate()
	add_child(sun)
	var sun_scale = randf_range(sun_min_scale, sun_max_scale)
	var sprite = sun_sprites[randi()%len(sun_sprites)]
	var amount_of_enemies = int(get_random_from_mean(sun_enemies_mean, sun_enemies_randomness))
	var amount_of_minerals = int(get_random_from_mean(sun_minerals_mean, sun_minerals_randomness))
	
	sun.init(sprite, amount_of_enemies, sun_name, amount_of_minerals, sun_scale)
	
	sun.position = Vector2(0,0)
			
func get_random(mean, randomness):
	return randf_range(-randomness, randomness) * mean

func get_random_from_mean(mean, randomness):
	return get_random(mean, randomness) + mean

