extends HBoxContainer

@export var increasing_texture: Texture2D
@export var decreasing_texture: Texture2D
@export var texture_min_size: Vector2 = Vector2(16, 24)

@export var stops := 3
@export var cutoffs: Array[float] = [0.0, 0.25, 0.5]

func update(rate_of_change: float) -> void:
	var amount := 0
	for cutoff: float in cutoffs:
		if abs(rate_of_change) < cutoff:
			break
		amount += 1
	
	for child in get_children():
		child.queue_free()
	
	for i in range(amount):
		var icon := TextureRect.new()
		icon.texture = increasing_texture if sign(rate_of_change) > 0 else decreasing_texture
		icon.custom_minimum_size = texture_min_size
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		add_child(icon)
	