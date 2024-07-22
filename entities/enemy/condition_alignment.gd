extends ConditionBehaviourTreeNode

@export var dot_product_minimum := 0.0

## Will return SUCCESS or FAILURE based on the actor's state. Generally this is an 'atomic' operation
## and should never report 'RUNNING'.
func update(actor : Node, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy
	var player : Player = _actor.player
	var dir_to_player := _actor.global_position.direction_to(player.global_position).normalized()
	return BehaviourState.SUCCESS if actor.transform.x.dot(dir_to_player) > dot_product_minimum else BehaviourState.FAILED
