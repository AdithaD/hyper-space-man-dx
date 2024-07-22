extends Resource
class_name BehaviourTreeBlackboard
## A container for a dictionary that will hold scratch data during the lifecycle of the behaviour tree.
## The tree's blackboard is given to every child during it's update call.

var _blackboard := {}

func set_value(key: Variant, value: Variant) -> void:
	_blackboard[key] = value
	
func erase(key: Variant) -> void:
	_blackboard.erase(key)
	
func get_value(key: Variant, default_value: Variant = null) -> Variant:
	if _blackboard.has(key):
		return _blackboard[key]
	else:
		return default_value
