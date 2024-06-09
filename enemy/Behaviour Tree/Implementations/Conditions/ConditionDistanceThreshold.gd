extends ConditionBehaviourTreeNode
class_name ConditionDistanceThreshold
## An condition that checks whether the actor is over or under a certain threshold distance.

## This class is not to be used, but extended.

## The distance the must be exceeded or not exceeded for the condition to evaluate SUCCESS
@export var threshold = 100.0

## Sets whether it is SUCCESS if it's greater or less than the threshold.
@export var is_greater_than_threshold = true

## Returns whether the target is greater or lower than the threshold. 
## If the target_node is null, it will fail.
func update(actor, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var target_node = get_target_node(actor, blackboard) 
	var origin_node = get_origin_node(actor, blackboard)
	
	if is_instance_valid(target_node):
		var distance = target_node.global_position.distance_to(origin_node.global_position)
		var valid_distance =  distance > threshold if is_greater_than_threshold else distance < threshold
		
		return BehaviourState.SUCCESS if valid_distance else BehaviourState.FAILED
	else:
		return BehaviourState.FAILED

## Returns the target node. Should be overriden by classes inheriting from this class.
func get_target_node(_actor, _blackboard: BehaviourTreeBlackboard) -> Node2D:
	return null
	
## Returns the origin node. Will be the actor by default. May be overriden by children.
func get_origin_node(_actor, _blackboard: BehaviourTreeBlackboard) -> Node2D:
	return _actor
