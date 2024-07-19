extends Node2D
class_name SolarSystemSpawner

signal solar_system_spawned(solar_system : SolarSystem)

@export var player: Player
@export var solar_system_scene: PackedScene

@export var grid_size: int
@export var min_distance: int
@export var max_distance: int
@export var min_planets: int
@export var max_planets: int
@export var min_solar_range: int
@export var max_solar_range: int

@export var solar_system_randomness: float

@onready var world : World = get_parent()

var sun_grid := {}
var explored_grid := {}
var start_pos: Vector2 = Vector2.ZERO
var sun_names_temp : Array[String] = ["Kepler", "HD", "2MASS", "KOI", "WASP", "K2", "HIP", "EPIC", "KELT", "Sol", "CoRoT", "Gliese", "OGLE", "Qatar", "HAT", "GJ", "KELT"]
var sun_names : Array[String] = []

var active := true

func generate_n_digit_numbers(n: int, amount: int) -> Array[String]:
	var result : Array[String] = []
	for i in range(amount):
		result.append(generate_number(n))
	return result
	
func generate_number(length: int) -> String:
	if length == 0:
		return ""
	else:
		return generate_number(length - 1) + str(int(randf_range(0, 10)))

func generate_sun_names() -> void:
	for sun_name : String in sun_names_temp:
		for j in range(2, 5):
			for k in generate_n_digit_numbers(j, 7):
				sun_names.append(sun_name + "-" + k)

func _ready() -> void:
	randomize()
	generate_sun_names()
	explored_grid[[0, 0]] = true
	
func _process(_delta : float) -> void:
	if active:
		var pos := Vector2i(player.global_position / grid_size)
		if not explored_grid.has(pos):
			#var time_left = get_node("/root/Main").time_left
			explored_grid[pos] = true
			#spawn(2, full_position, start_pos, ((time_left * min_distance) + max_distance * (game_time - time_left)) / game_time)
			spawn(2, player.global_position, start_pos, randi_range(min_distance, max_distance) * grid_size)
		
func create_solar_system(x : float, y : float, number_of_planets : int, spread : float) -> SolarSystem:
	var solar_system : SolarSystem = solar_system_scene.instantiate()
	add_child(solar_system)

	solar_system.position.x = x
	solar_system.position.y = y
	
	#solar_system.init(n, spread, sun_sprite_array, planet_sprite_array, sun_names[randi()%len(sun_names)])
	solar_system.init(world, grid_size, number_of_planets, spread, sun_names[randi() %len(sun_names)])

	return solar_system
	
#spawns solar sytem dist from pos in semicircle away from origin
func spawn(amount: int, player_position: Vector2, origin : Vector2, distance_from_player : float) -> void:
	for i in range(amount):
		var _rotation := randf_range( - 0.5 * PI, 0.5 * PI)
		
		var goal_pos := (player_position + (origin.direction_to(player_position) * distance_from_player).rotated(_rotation))
		var goal_x_grid := int(goal_pos.x / grid_size)
		var goal_y_grid := int(goal_pos.y / grid_size)
		
		if not sun_grid.has([goal_x_grid, goal_y_grid]):
			var rand_offset := floori(solar_system_randomness * grid_size)
			
			var x := goal_x_grid * grid_size + randi_range( - rand_offset, rand_offset)
			var y := goal_y_grid * grid_size + randi_range( - rand_offset, rand_offset)
			
			var number_of_planets := randi_range(min_planets, max_planets + 1)
			
			var spread := randi_range(min_solar_range, max_solar_range)
			
			var solar_system := create_solar_system(x, y, number_of_planets, spread)
			
			sun_grid[[goal_x_grid, goal_y_grid]] = true
			solar_system_spawned.emit(solar_system)
	
func start_spawn() -> void:
	spawn(3, Vector2(1, 0), Vector2(0, 0), grid_size * 4)
	spawn(3, Vector2( - 1, 0), Vector2(0, 0), grid_size * 4)
	spawn(3, Vector2(0, 1), Vector2(0, 0), grid_size * 4)
	spawn(3, Vector2(0, -1), Vector2(0, 0), grid_size * 4)
