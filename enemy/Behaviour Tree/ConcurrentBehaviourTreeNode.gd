@icon("res://enemy/Behaviour Tree/concurrent.svg")
extends BehaviourTreeNode
class_name ConcurrentBehaviourTreeNode
## A node in the BehaviourTree system. Returns SUCCESS only if all children report success.
## Runs all children "concurrently" in child order, every time update is called.
## Actions should be placed AFTER conditions in the child order.
## Particularly useful for ensuring state is still valid at the time of execution
## as all child conditions will be evaluated everytime.

# Stores the index of the last child that reported the state 'RUNNING'.
var _current_running_index = -1

## Updates all children in child order, continuing onto the next only if the previous child returned SUCCESS.
func update(actor, blackboard) -> BehaviourState:
	var i = 0
	while i < get_child_count():
		var child = get_child(i) as BehaviourTreeNode
		
		var child_result = child.update(actor, blackboard)
		# if a condition is still running, it will check every condition again.
		# this is difference to the sequence behaviour node.
		if not child_result == BehaviourState.SUCCESS:
			if child_result == BehaviourState.RUNNING:
				_current_running_index = i
				
			return child_result
		else:
			i += 1
	
	return BehaviourState.SUCCESS

## Resets all children nodes,
func reset_state() -> void:
	for child : BehaviourTreeNode in get_children():
		child.reset_state()
	_current_running_index = -1
	pass

## Will return the last child node that returned a RUNNING state.
func get_active_node() -> BehaviourTreeNode:
	return get_child(_current_running_index).get_active_node() if _current_running_index >= 0 else null
