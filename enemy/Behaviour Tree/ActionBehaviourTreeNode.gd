@icon("res://enemy/Behaviour Tree/action.svg")
extends BehaviourTreeNode
class_name ActionBehaviourTreeNode
## A base class to inherit that represents an action in the behaviour tree system.
## As this is a leaf node, this should not have any children.

func _ready() -> void:
	assert(get_children().size() == 0, "Action nodes should node have any children")

## This function should update the actor's state or queue effects to the game world.
## This is to be overidden by an inherited class.
func update(_actor, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	# call a member function of the actor
	return BehaviourState.SUCCESS

## Returns self as it is a leaf node.
func get_active_node() -> BehaviourTreeNode:
	return self
