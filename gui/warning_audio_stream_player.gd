extends AudioStreamPlayer

@export var controls: Array[Control]

func _ready() -> void:
	for c in controls:
		c.visibility_changed.connect(_on_visibility_changed.bind(c))

func _on_visibility_changed(control: Control) -> void:
	if control.visible:
		play()
	else:
		stop()