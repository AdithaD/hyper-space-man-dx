extends Node2D

var exploration_vector : Vector2

func _ready() -> void:
	exploration_vector = Vector2.RIGHT.rotated(randf_range(-1, 1) * PI)
	
	for child in get_children():
		child.exploration_vector = exploration_vector
