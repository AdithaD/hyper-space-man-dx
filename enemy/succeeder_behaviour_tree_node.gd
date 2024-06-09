extends BehaviourTreeNode

func update(actor, blackboard) -> BehaviourState:
	get_child(0).update(actor, blackboard)
	return BehaviourState.SUCCESS
