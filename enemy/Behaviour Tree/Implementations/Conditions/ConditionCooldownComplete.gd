extends ConditionBehaviourTreeNode
class_name ConditionCooldownComplete
## An condition that checks whether a cooldown has successfuly completed.
## Utilises the blackboard to maintain it's timers internal state.
## Very useful to use under sequence node to gatekeep an action.
## Part of the behaviour tree system.

## The duration of the cooldown.
@export var cooldown = 4.0
@export var reset_on_success = true

func init_behaviour(actor, blackboard: BehaviourTreeBlackboard):
	super(actor, blackboard)
	blackboard.set_value(get_blackboard_key(), Time.get_ticks_msec())

## Will progress the cooldown timer and save its state to the blackboard.
## Will return FAILED if the cooldown is still active, otherwise on the next update
## it will return success, and reset the timer
func update(_actor, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var bb_ticks = blackboard.get_value(get_blackboard_key(), Time.get_ticks_msec())
	var time_elapsed = Time.get_ticks_msec() - bb_ticks
	
	if time_elapsed < cooldown * 1000:
		return BehaviourState.FAILED
	else:
		if reset_on_success:
			var new_time = Time.get_ticks_msec()
			blackboard.set_value(get_blackboard_key(), new_time)

			#print("\n", name, ":\nlast time was: ", bb_ticks, " \n new time: ", new_time, " cooldown: ", cooldown)
		return BehaviourState.SUCCESS

## Returns a unique key identifying this leaf node for use with the blackboard.
func get_blackboard_key() -> String:
	return str(get_instance_id(), "_timer")
