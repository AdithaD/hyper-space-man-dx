extends Node2D
class_name TargetLockAcquirer
signal lock_acquired(target: Node2D)
signal lock_lost

@export var lock_time: float
@export var forgiveness_time: float
@export var enabled := false


var acquired_target: Node2D

var _tracking_target: Node2D

var _forgiveness_timer := 0.0

@onready var target_lock_timer: Timer = $TargetLockTimer
@onready var dss: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

func _ready() -> void:
	target_lock_timer.wait_time = lock_time

func _physics_process(delta: float) -> void:
	if enabled:
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_bodies = false
		query.collide_with_areas = true
		query.collision_mask = 0b1000

		var collisions := dss.intersect_point(query, 1)
		if collisions.size() > 0:
			var hurtbox : HurtboxComponent = collisions.front().collider
			var target := hurtbox.get_parent()
			
			if not target.is_in_group("enemy"):
				return
				
			if target.is_dead:
				return

			if _tracking_target != target:
				reset_lock()

				_tracking_target = target
				target_lock_timer.start(0)
				$LockAcquiringProgressSound.play()

				prints("new target ", target.name)
		else:
			if _tracking_target:
				if _forgiveness_timer < forgiveness_time:
					_forgiveness_timer += delta
				else:
					$LockAcquiringProgressSound.stop()
					print("lock lost")
					reset_lock()

func reset_lock() -> void:
	if acquired_target:
		lock_lost.emit()

	acquired_target = null
	_tracking_target = null
	target_lock_timer.stop()
	_forgiveness_timer = 0.0

func get_acquirement_progress() -> float:
	return 1.0 - target_lock_timer.time_left / target_lock_timer.wait_time

func get_current_target() -> Node2D:
	return acquired_target

func _on_target_lock_timer_timeout() -> void:
	acquired_target = _tracking_target
	lock_acquired.emit(_tracking_target)
	$LockAcquiringProgressSound.stop()
	$LockAcquiredSound.play()

func set_enabled(state: bool) -> void:
	enabled = state
	reset_lock()
