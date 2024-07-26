extends Area2D
class_name PlayerInteractArea

@export var interactor_key: StringName
@export var source_node: Node2D

signal player_entered(player: Player)
signal player_exited(player: Player)

@onready var interaction_delegator: InteractionDelegator = get_tree().get_first_node_in_group("interaction_delegator")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	interaction_delegator.register_interactor(self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered.emit(body)
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_exited.emit(body)
