extends ActionBehaviourTreeNode

func update(actor, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	actor.shoot()
	return BehaviourState.SUCCESS
