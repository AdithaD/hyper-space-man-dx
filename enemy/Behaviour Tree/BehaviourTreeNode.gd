extends Node
class_name BehaviourTreeNode
## A base class for all base behaviour tree nodes to inherit from.
## Has method to update and return a behaviour state and reset its state from previous executions.

## The possible values to return once updated.
enum BehaviourState {
	## The update function has completed execution successfully this frame.
	SUCCESS, 
	## The update function has not completed its execution fully this frame.
	RUNNING,
	## The update function has completed execution and cleanly reported a failure.
	FAILED
}

## Propogates from the tree down to intitialise any special behaviours.
func init_behaviour(actor, blackboard: BehaviourTreeBlackboard):
	for child in get_children():
		child.init_behaviour(actor, blackboard)
	

## The update function is called to update the child nodes and their children (if any)
## Returns a behaviour state that is an aggregate of its children states, or if a it's
## a leaf node, is solely dependent on the leaf node itself.
func update(_actor, _blackboard) -> BehaviourState:
	return BehaviourState.SUCCESS

## Resets the state of the node to be executed again.
func reset_state() -> void:
	pass

## Returns which child (or self if childless) is currently reporting RUNNING.
func get_active_node() -> BehaviourTreeNode:
	return self
	
func debug_print():
	print(get_path())
