extends ConditionBehaviourTreeNode

@export var dot_product_minimum = 0.0

## Will return SUCCESS or FAILURE based on the actor's state. Generally this is an 'atomic' operation
## and should never report 'RUNNING'.
func update(actor : Enemy, _blackboard) -> BehaviourState:
	var player = actor.player
	var dir_to_player := actor.global_position.direction_to(player.global_position).normalized()
	return BehaviourState.SUCCESS if actor.transform.x.dot(dir_to_player) > dot_product_minimum else BehaviourState.FAILED
