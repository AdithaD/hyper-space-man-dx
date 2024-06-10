extends Control

@export var player: Player

@export var enemy_detection_range = 1000.0

@export var marker_size: float = 32
@export var padding: float = 32

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy") \
			.filter(func(x):
				return player.global_position.distance_to(x.global_position) < enemy_detection_range) \
			.filter(func(x):
				return not is_on_screen(x.global_position)) \
			.filter(func(x): return not x.is_dead)
			
	for en in enemies:
		var vec = player.global_position.direction_to(en.global_position)
		draw_vec(vec, Color.RED)

	if player.mine_anchor:
		if not is_on_screen(player.mine_anchor.global_position):
			var vec = player.global_position.direction_to(player.mine_anchor.global_position)
			draw_vec(vec, Color.GREEN)

func draw_vec(vec: Vector2, color: Color):
	var x0 = size.x / 2
	var y0 = size.y / 2
	
	var x1 = padding
	var y1 = size.y - padding
	
	var x2 = size.x - padding
	var y2 = padding
	
	var vx = vec.x
	var vy = vec.y
	
	var ex = x2 if vx > 0 else x1
	var ey = y1 if vy > 0 else y2
	#prints("E:", ex, ey)
	var cx = 0
	var cy = 0
	
	var angle = 0
	if is_zero_approx(vx):
		cx = x0
		cy = ey
	elif is_zero_approx(vy):
		cx = ex
		cy = y0
	else:
		# general case
		var tx = (ex - x0) / vx
		var ty = (ey - y0) / vy
		#prints("T:", tx, ty)
		if tx <= ty:
			cx = ex
			cy = y0 + tx * vy
			angle = 0.0 if vx > 0 else PI
		else:
			cx = x0 + ty * vx
			cy = ey
			angle = PI / 2 if vy > 0 else - PI / 2
							
	#prints("C:", cx, cy)
	draw_set_transform(Vector2(cx, cy), angle, Vector2.ONE * marker_size)
	draw_polygon(_get_triangle_points(), _get_triangle_colours(color))

func is_on_screen(location: Vector2) -> bool:
	return get_rect().has_point(player.global_position - location + size / 2)

func _get_triangle_points() -> PackedVector2Array:
	var points: PackedVector2Array = [
		Vector2( - 0.5, -0.5),
		Vector2( - 0.5, 0.5),
		Vector2(0.5, 0)
	]
	return points
	
func _get_triangle_colours(color: Color=Color.RED) -> PackedColorArray:
	var points: PackedColorArray = [
		color,
		color,
		color
	]
	return points
