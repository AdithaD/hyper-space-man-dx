extends ColorRect

@export var gradient: Gradient

func set_ratio(ratio: float) -> void:
	color = gradient.sample(ratio)