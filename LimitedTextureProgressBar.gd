extends TextureProgressBar

@export var limit = 64

func set_ratio(new_ratio: float):
	value = limit * new_ratio
