extends Node
class_name InteractionDelegate

@export var interactor_key: StringName
@export var player: Player
@export var should_remove_player_control := true

var _interacting_node: Node2D = null

func interact(_source_node: Node2D) -> void:
	if _interacting_node:
		finish_interaction(_interacting_node)
	else:
		_interacting_node = _source_node

func finish_interaction(_source_node: Node2D) -> void:
	_interacting_node = null
