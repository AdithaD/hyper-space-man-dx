@icon("res://enemy/Behaviour Tree/sequence.svg")
extends BehaviourTreeNode
class_name SequenceBehaviourTreeNode
## A node in the BehaviourTree system. Returns SUCCESS once all nodes have return successful.
## Remembers which child last reported a RUNNING state, and will continue execution from that index.
## Useful for conduct a chain of events that may take multiple frames to complete.

## Stores which child is currently RUNNING
var child_update_index := 0 

## Iterates through its children in node order until done or a child returns that it is running.
## Will continue execution of children starting from [param child_update_index] when called.
func update(actor, blackboard) -> BehaviourState:
	while child_update_index < get_child_count():
		var child = get_child(child_update_index) as BehaviourTreeNode
		
		var child_result = child.update(actor, blackboard)
		
		if not child_result == BehaviourState.SUCCESS:
			return child_result
		else:
			# Don't increment on the last one.
			if child_update_index + 1 < get_child_count():
				child_update_index += 1
			else:
				# Loop
				reset_state()
				return BehaviourState.SUCCESS
	
	return BehaviourState.SUCCESS
## Resets all children to 0, and sets [param child_update_index] back to the first child.
func reset_state() -> void:
	for child : BehaviourTreeNode in get_children():
		child.reset_state()
	child_update_index = 0
	pass

## Returns the last child that reported 'RUNNING'
func get_active_node() -> BehaviourTreeNode:
	return get_child(child_update_index).get_active_node() if child_update_index >= 0 else null
