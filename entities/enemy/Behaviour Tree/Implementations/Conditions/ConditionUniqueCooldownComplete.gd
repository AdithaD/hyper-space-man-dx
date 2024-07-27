extends ConditionCooldownComplete

@export var key := "default"

func get_blackboard_key() -> String:
	return str(key)
