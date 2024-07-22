extends "res://enemy/Behaviour Tree/BehaviourTreeNode.gd"
class_name InverterBehaviourTreeNode
## A node in the BehaviourTree system that inverts SUCCESS and FAILED states.
## As this is a 'decorator' node, it should only ever have one child.

func _ready() -> void:
	if get_child_count() > 1:
		push_error("Decorator must only have one child")
		
		
# Inverts the SUCCESS and FAILED states, the RUNNING state is not changed.
func update(actor, blackboard) -> BehaviourState:
	var result = get_child(0).update(actor, blackboard)
	
	match(result):
		BehaviourState.SUCCESS:
			return BehaviourState.FAILED
		BehaviourState.FAILED:
			return BehaviourState.SUCCESS
	
	return result

func get_active_node() -> BehaviourTreeNode:
	return get_child(0).get_active_node()
