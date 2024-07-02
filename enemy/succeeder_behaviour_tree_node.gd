extends BehaviourTreeNode

func update(actor: Node, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	get_child(0).update(actor, blackboard)
	return BehaviourState.SUCCESS
