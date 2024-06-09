extends ActionBehaviourTreeNode

@export var minimum_coherence_range = 100.0
@export var maximum_coherence_range = 1000.0

@export var force : float = 500.0

func update(actor: Enemy, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var enemies_in_range = actor.enemy_group.filter(func(x): return x != actor \
			and actor.global_position.distance_to(x.global_position) < maximum_coherence_range \
			and actor.global_position.distance_to(x.global_position) > minimum_coherence_range)
	
	if enemies_in_range.is_empty():
		return BehaviourState.FAILED
	
	var dir := Vector2()
	for en in actor.enemy_group:
		dir += actor.global_position.direction_to(en.global_position)
		
	actor.velocity += dir.normalized() * force * blackboard.get_value("delta")
	
	return BehaviourState.SUCCESS
	
