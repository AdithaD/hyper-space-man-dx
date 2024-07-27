extends Node
class_name InteractionDelegator

var _delegate_map: Dictionary = {}

var _stack := []

func push(interactor: PlayerInteractArea) -> void:
	_stack.push_back(interactor)

func pop() -> void:
	var back: PlayerInteractArea = _stack.back()
	var interaction_delegate: InteractionDelegate = _delegate_map.get(back.interactor_key)
	if interaction_delegate:
		interaction_delegate.interact(back.source_node)

func clear(interactor: PlayerInteractArea) -> void:
	var interaction_delegate: InteractionDelegate = _delegate_map.get(interactor.interactor_key)
	if interaction_delegate:
		interaction_delegate.finish_interaction(interactor.source_node)
	_stack.erase(interactor)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not _stack.is_empty():
			pop()

func _ready() -> void:
	for child in get_children():
		_register_interaction_delegate(child)

func _register_interaction_delegate(interactor: InteractionDelegate) -> void:
	_delegate_map[interactor.interactor_key] = interactor
	
func register_interactor(interactor: PlayerInteractArea) -> void:
	interactor.player_entered.connect(push.bind(interactor).unbind(1))
	interactor.player_exited.connect(clear.bind(interactor).unbind(1))