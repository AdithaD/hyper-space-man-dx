extends TextureProgressBar

@export var limit := 64

func set_ratio(new_ratio: float) -> void:
	value = limit * new_ratio
