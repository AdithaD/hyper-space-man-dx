extends ActionBehaviourTreeNode

@export var maximum_separation_range := 150.0
@export var force: float = 500.0

func update(actor: Node, _blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy

	var enemies_in_range := _actor.local_group.filter(_filter.bind(actor))

	if enemies_in_range.is_empty():
		return BehaviourState.FAILED
	
	var dir := Vector2()
	for en in _actor.local_group:
		dir += _actor.global_position.direction_to(en.global_position)
		
	_actor.desired_rotation += - dir.normalized() * force
	
	return BehaviourState.SUCCESS

func _filter(x: Enemy, actor: Node) -> bool:
	return x != actor and actor.global_position.distance_to(x.global_position) < maximum_separation_range