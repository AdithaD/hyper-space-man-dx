extends HBoxContainer

signal selected

@export var upgrade : TieredUpgrade

@export var normal_color : Color
@export var normal_label_style : StyleBox

@export var selected_color : Color
@export var selected_label_style : StyleBox

@onready var item_label: Label = $ItemLabel
@onready var line: ColorRect = $Control/Line

var is_selected : bool:
	get:
		return _is_selected
	set(value):
		set_selected(value)

var _is_selected := false

func _ready() -> void:
	item_label.text = upgrade.upgrade_name
	item_label.gui_input.connect(_on_gui_input)
	set_selected(_is_selected)
	print("initied")
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			set_selected(not _is_selected)

func set_selected(value: bool) -> void:
	_is_selected = value
	
	item_label.add_theme_stylebox_override("normal", selected_label_style if _is_selected else normal_label_style)
	line.color = selected_color if _is_selected else normal_color
	
	if _is_selected:
		selected.emit()
