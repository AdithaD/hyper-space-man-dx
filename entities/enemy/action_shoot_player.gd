extends ActionBehaviourTreeNode

func update(actor: Node, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy
	_actor.shoot()
	return BehaviourState.SUCCESS
