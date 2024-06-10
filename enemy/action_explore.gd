extends "res://enemy/action_chase_player.gd"

@export var max_distance_from_home: float = 2000

func update(actor: Enemy, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	return super(actor, blackboard)

func _get_dir_to_target(actor: Enemy, _blackboard: BehaviourTreeBlackboard):
	return actor.exploration_vector
