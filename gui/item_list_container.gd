extends HBoxContainer

@onready var item_list = $ItemList
@onready var item_controls = $ItemListControls

var _map = {}

func _ready():
	for child in item_controls.get_children():
		var index = item_list.add_item(child.name)
		_map[index] = child
	
	item_list.item_selected.connect(_on_item_selected)

func _on_item_selected(index: int) -> void:
	var selected_child = _map[index]

	for child in item_controls.get_children():
		child.hide()

	selected_child.show()
	print(selected_child.name)