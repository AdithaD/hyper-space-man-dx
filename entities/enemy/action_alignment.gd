extends ActionBehaviourTreeNode

@export var maximum_alignment_range = 500.0
@export var force : float = 500.0

func update(actor: Enemy, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var enemies_in_range = actor.enemy_group.filter(func(x): return x != actor \
			and actor.global_position.distance_to(x.global_position) < maximum_alignment_range) 
	
	if enemies_in_range.is_empty():
		return BehaviourState.FAILED
	
	var dir := Vector2()
	for en in actor.enemy_group:
		dir += en.velocity.normalized()
		
	actor.velocity += -dir.normalized() * force * blackboard.get_value("delta")
	
	#var angle_diff = actor.transform.x.angle_to(actor.velocity.normalized())
	#var rotation = signf(angle_diff) * min(abs(angle_diff), actor.angular_velocity *  blackboard.get_value("delta"))
	#actor.rotate(rotation)
	
	return BehaviourState.SUCCESS
