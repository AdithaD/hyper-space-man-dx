extends "res://enemy/action_chase_player.gd"

func _get_dir_to_target(actor: Enemy, _blackboard: BehaviourTreeBlackboard):
	return actor.exploration_vector
