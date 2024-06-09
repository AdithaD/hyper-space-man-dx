extends ActionBehaviourTreeNode

func update(actor: Enemy, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var player = actor.player
	
	if player:
		var dir_to_target = _get_dir_to_target(actor, blackboard)
		
		if actor.transform.x.normalized().dot(dir_to_target) < 0.95:
			_turn_towards(actor, player.global_position, blackboard.get_value("delta"))
		
		_accelerate(actor, blackboard.get_value("delta"))
		
		return BehaviourState.SUCCESS
	else:
		return BehaviourState.FAILED

func _accelerate(actor: Enemy, delta: float):
	actor.velocity = (actor.velocity + actor.transform.x * actor.acceleration * delta).limit_length(actor.max_speed)
	
func _turn_towards(actor: Enemy, location: Vector2, delta: float):
	var angle_diff = actor.global_position.angle_to_point(location)
	var rotation =signf(angle_diff) * min(abs(angle_diff), actor.angular_velocity * delta)
	actor.rotate(rotation)

func _get_dir_to_target(actor: Enemy, blackboard: BehaviourTreeBlackboard):
	return actor.global_position.direction_to(actor.player.global_position)
