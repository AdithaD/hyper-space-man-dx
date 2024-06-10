extends Control

enum TILE {
	PLAYER, PLANET, SUN, EMPTY
}

@export var player: Player

@export var sun_size = 1024
@export var grid_scale := 1024
@export var grid_size := 10

@onready var planets = get_tree().get_nodes_in_group("planet")
@onready var suns = get_tree().get_nodes_in_group("sun")
@onready var enemies = get_tree().get_nodes_in_group("enemy")

var last_draw_position = Vector2i()

func _physics_process(_delta: float) -> void:
	var player_pos = Vector2i(player.global_position / grid_scale)
	if player_pos != last_draw_position or enemies.size() > 0:
		last_draw_position = player_pos
		planets = get_tree().get_nodes_in_group("planet")
		suns = get_tree().get_nodes_in_group("sun")
		enemies = get_tree().get_nodes_in_group("enemy")
		queue_redraw()

func _draw() -> void:
	var actual_size = size.x / grid_size
	
	var grid = []
	grid.resize(grid_size * grid_size)
	grid.fill(TILE.EMPTY)

	draw_rect(Rect2(Vector2(), size), Color.BLACK)
	draw_rect(Rect2(Vector2(), size), Color.MIDNIGHT_BLUE, false, 2.0)
	
	var _planets = planets.filter(func(x): return x.global_position.distance_to(player.global_position) < grid_scale * grid_size / 2) \
							.map(func(x): return Vector2i((x.global_position - player.global_position) / grid_scale))
							
	for p in _planets:
		var i = (p.y + grid_size / 2)
		var j = (p.x + grid_size / 2)
		var index = i * grid_size + j
		
		draw_rect(Rect2(Vector2(j, i) * actual_size, Vector2(actual_size, actual_size)), Color.BLUE)
		grid[index] = TILE.PLANET
	
	var _suns = suns.filter(func(x): return x.global_position.distance_to(player.global_position) < grid_scale * grid_size / 2) \
							.map(func(x): return Vector2i((x.global_position - player.global_position) / grid_scale))
							
	for s in _suns:
		var i = (s.y + grid_size / 2)
		var j = (s.x + grid_size / 2)
		var index = i * grid_size + j
		grid[index] = TILE.SUN
		
		var _i = clamp(i - 1, 0, grid_size - 1)
		var _j = clamp(j - 1, 0, grid_size - 1)
		var sun_grid_size = max(1, sun_size / grid_scale)
		draw_rect(Rect2(Vector2(_j, _i) * actual_size, Vector2(actual_size * sun_grid_size, actual_size * sun_grid_size)), Color.YELLOW)

	var _enemies = enemies.filter(func(x): return not x.is_dead and x.global_position.distance_to(player.global_position) < grid_scale * grid_size / 2) \
							.map(func(x): return Vector2i((x.global_position - player.global_position) / grid_scale))
	for e in _enemies:
		var i = (e.y + grid_size / 2)
		var j = (e.x + grid_size / 2)
		draw_rect(Rect2(Vector2(j, i) * actual_size, Vector2(actual_size, actual_size)), Color.RED)
	
	draw_rect(Rect2(Vector2(grid_size / 2, grid_size / 2) * actual_size, Vector2(actual_size, actual_size)), Color.PURPLE)
