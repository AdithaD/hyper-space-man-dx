extends Label
class_name SelectableLabel

signal selected
signal deselected

@export var normal_style : StyleBox
@export var selected_style : StyleBox

@export var is_selected : bool = false:
	set(value):
		is_selected = value
		add_theme_stylebox_override("normal", selected_style if is_selected else normal_style)
		if value:
			selected.emit()
		else:
			deselected.emit()

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			
			is_selected = not is_selected
