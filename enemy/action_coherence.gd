extends ActionBehaviourTreeNode

@export var minimum_coherence_range := 100.0
@export var maximum_coherence_range := 1000.0

@export var force : float = 500.0

func update(actor: Node, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy
	var enemies_in_range := _actor.enemy_group.filter(func(x: Enemy) -> bool: return x != actor \
			and _actor.global_position.distance_to(x.global_position) < maximum_coherence_range \
			and _actor.global_position.distance_to(x.global_position) > minimum_coherence_range)
	
	if enemies_in_range.is_empty():
		return BehaviourState.FAILED
	else:
		var dir := Vector2()
		for en in _actor.enemy_group:
			dir += _actor.global_position.direction_to(en.global_position)
			
		_actor.desired_rotation += dir.normalized() * force
		
		return BehaviourState.SUCCESS
	
