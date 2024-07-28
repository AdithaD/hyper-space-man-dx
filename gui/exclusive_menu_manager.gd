extends Node
class_name ExclusiveMenuManager

@export var menus: Array[Control] = []
@export var player: Player

var has_control: bool = false

func try_open_menu(menu: Control, take_control:=true) -> void:
	if not menus.any(func(x: Control) -> bool: return x.visible):
		menu.show()
		has_control = take_control
		if has_control:
			player.has_control = false

func close_menu(menu: Control) -> void:
	menu.hide()
	has_control = false
	player.has_control = true
	
func toggle_menu(menu: Control) -> void:
	if menu.visible:
		close_menu(menu)
	else:
		try_open_menu(menu)
