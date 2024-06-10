extends Control

enum TILE {
	PLAYER, PLANET, SUN, EMPTY
}

@export var player: Player

@export var border_width: float = 2.0
@export var sun_size = 2
@export var grid_scale := 1024
@export var grid_size := 10

@export_subgroup("Colours")
@export var background_color: Color = Color.BLACK
@export var border_color: Color = Color.MIDNIGHT_BLUE
@export var player_color: Color = Color.PURPLE
@export var planet_color: Color = Color.GREEN
@export var sun_color: Color = Color.YELLOW
@export var enemy_color: Color = Color.RED
@export var space_station_color: Color = Color.LIGHT_BLUE

@onready var planets = get_tree().get_nodes_in_group("planet")
@onready var suns = get_tree().get_nodes_in_group("sun")
@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var space_stations = get_tree().get_nodes_in_group("space_station")

var last_draw_position = Vector2i()

func _physics_process(_delta: float) -> void:
	var player_pos = Vector2i(player.global_position / grid_scale)
	if player_pos != last_draw_position or enemies.size() > 0:
		last_draw_position = player_pos
		planets = get_tree().get_nodes_in_group("planet")
		suns = get_tree().get_nodes_in_group("sun")
		enemies = get_tree().get_nodes_in_group("enemy")
		space_stations = get_tree().get_nodes_in_group("space_station")
		queue_redraw()

func _draw() -> void:
	var actual_size = size.x / grid_size
	
	# draw background and border
	draw_rect(Rect2(Vector2(), size), background_color)
	draw_rect(Rect2(Vector2(), size), border_color, false, border_width)
	
	# draw solar system objects
	draw_elements(planets, planet_color)
	draw_elements(suns, sun_color, sun_size)
	draw_elements(space_stations, space_station_color)
	
	# draw alive enemies
	var _enemies = enemies.filter(func(x): return not x.is_dead)
	draw_elements(_enemies, enemy_color)

	# draw player
	draw_rect(Rect2(Vector2(grid_size / 2, grid_size / 2) * actual_size, Vector2(actual_size, actual_size)), player_color)

func draw_elements(array: Array, color: Color, element_size: int=1) -> void:
	var actual_size = size.x / grid_size
	var _array = array.filter(func(x): return _is_on_grid(x)).map(func(x): return Vector2i((x.global_position - player.global_position) / grid_scale))
							
	for e in _array:
		var i = (e.y + grid_size / 2)
		var j = (e.x + grid_size / 2)
		
		var _i = clamp(i - floori(element_size / 2), border_width, grid_size - 1 - border_width)
		var _j = clamp(j - floori(element_size / 2), border_width, grid_size - 1 - border_width)

		draw_rect(Rect2(Vector2(_j, _i) * actual_size, Vector2(actual_size * element_size, actual_size * element_size)), color)

func _is_on_grid(location: Node2D):
	return location.global_position.distance_to(player.global_position) < grid_scale * grid_size / 2