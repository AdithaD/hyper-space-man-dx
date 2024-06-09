extends ConditionBehaviourTreeNode

@export var distance_threshold = 1000.0

func update(actor, _blackboard) -> BehaviourState:
	return BehaviourState.SUCCESS if actor.global_position.distance_to(actor.player.global_position) < distance_threshold else BehaviourState.FAILED
