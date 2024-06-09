@icon("res://enemy/Behaviour Tree/condition.svg")
extends BehaviourTreeNode
class_name ConditionBehaviourTreeNode
## A base class to inherit that represents a condition evaluating actor state in the behaviour tree system.
## Particularly useful to use under concurrent and sequence nodes.
## As this is a leaf node, this should not have any children.

func _ready() -> void:
	assert(get_children().size() == 0, "Condition nodes should node have any children")

## Will return SUCCESS or FAILURE based on the actor's state. Generally this is an 'atomic' operation
## and should never report 'RUNNING'.
func update(_actor, _blackboard) -> BehaviourState:
	# call a member function of the actor
	return BehaviourState.SUCCESS

## Returns self as it is a leaf node.
func get_active_node() -> BehaviourTreeNode:
	return self
