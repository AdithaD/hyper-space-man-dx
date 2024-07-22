extends ConditionBehaviourTreeNode

@export var distance_threshold := 1000.0

func update(actor : Node, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy
	return BehaviourState.SUCCESS if _actor.global_position.distance_to(_actor.player.global_position) < distance_threshold else BehaviourState.FAILED
