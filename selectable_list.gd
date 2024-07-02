extends VBoxContainer

signal item_selected(item: Control)

var items : Array[Control] = []

var selected_item : Control

func _ready() -> void:
	items.assign(get_children())
	for item in items:
		append_item(item)
	
func append_item(item: Control) -> void:
	if not get_children().has(item):
		add_child(item)
		items.append(item)
	item.selected.connect(_on_item_selected.bind(item))
	
func _on_item_selected(item: Control) -> void:
	selected_item = item
	for i in items:
		if i != selected_item:
			i.is_selected = false 
	item_selected.emit(item)
