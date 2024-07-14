extends ActionBehaviourTreeNode

@export var force := 2.0

func update(actor: Node, blackboard: BehaviourTreeBlackboard) -> BehaviourState:
	var _actor := actor as Enemy
	var player : Player = _actor.player
	
	if player:
		var dir_to_target := _get_dir_to_target(_actor, blackboard)
		
		#if _actor.transform.x.normalized().dot(dir_to_target) < 0.95:
		_actor.chase_dir += dir_to_target.normalized() * force
		
		return BehaviourState.SUCCESS
	else:
		return BehaviourState.FAILED

func _accelerate(actor: Enemy, delta: float) -> void:
	actor.velocity = (actor.velocity + actor.transform.x * actor.acceleration * delta).limit_length(actor.max_speed)
	
func _turn_towards(actor: Enemy, location: Vector2, delta: float) -> void:
	var angle_diff := actor.global_position.angle_to_point(location)
	var rotation : float = signf(angle_diff) * min(abs(angle_diff), actor.angular_velocity * delta)
	actor.rotate(rotation)

func _get_dir_to_target(actor: Enemy, _blackboard: BehaviourTreeBlackboard) -> Vector2:
	return actor.global_position.direction_to(actor.player.global_position)
