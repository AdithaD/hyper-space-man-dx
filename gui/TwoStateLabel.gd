extends Label

@export var enabled_color : Color
@export var disabled_color : Color

var enabled:
	set(value):
		enabled = value
		modulate = enabled_color if enabled else disabled_color
