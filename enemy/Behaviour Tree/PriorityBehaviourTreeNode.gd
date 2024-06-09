@icon("res://enemy/Behaviour Tree/priority_selector.svg")
extends BehaviourTreeNode
class_name PriorityBehaviourTreeNode
## A node in the BehaviourTree system. Goes through children in child order 
## and returns SUCCESS once one node has returned successful.
## It will start from the first child every update step, ensuring that an available higher priority behaviour will be executed
## The node will stop execution once a child it's currently updating has returned SUCCESS.
## It effectively prioritises child behaviours over one another.

## Stores which child is currently RUNNING
var child_update_index := 0 

## Iterates through its children in node order until a child returns RUNNING or SUCCESS.
func update(actor, blackboard) -> BehaviourState:
	var i = 0
	while i < get_child_count():
		var child = get_child(i) as BehaviourTreeNode
		var child_result = child.update(actor, blackboard)
		
		if not child_result == BehaviourState.FAILED:
			# reset the later node that returned running last update
			if child_update_index != i:
				var last_running = get_child(child_update_index) as BehaviourTreeNode
				last_running.reset_state()
			
			child_update_index = i
			return child_result
		else:
			i += 1
	
	return BehaviourState.FAILED

func reset_state() -> void:
	for child : BehaviourTreeNode in get_children():
		child.reset_state()
	child_update_index = 0
	pass


func get_active_node() -> BehaviourTreeNode:
	return get_child(child_update_index).get_active_node() if child_update_index >= 0 else null
