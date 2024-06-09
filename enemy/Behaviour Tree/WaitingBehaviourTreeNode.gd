extends BehaviourTreeNode
class_name WaitingBehaviourTreeNode
## While the child node returns either success or failure, return a running state.
## Very useful to block sequences whilst waiting for a cooldown without killing the sequence.

@export var wait_on_fail = true

func _ready() -> void:
	if get_child_count() > 1:
		push_error("Decorator must only have one child")
		
		
# Inverts the SUCCESS and FAILED states, the RUNNING state is not changed.
func update(actor, blackboard) -> BehaviourState:
	var result = get_child(0).update(actor, blackboard)
	
	match(result):
		BehaviourState.SUCCESS:
			return BehaviourState.RUNNING if not wait_on_fail else BehaviourState.SUCCESS
		BehaviourState.FAILED:
			return BehaviourState.RUNNING if wait_on_fail else BehaviourState.FAILED
	
	return result

func get_active_node() -> BehaviourTreeNode:
	return get_child(0).get_active_node()
