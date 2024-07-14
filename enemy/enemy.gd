extends CharacterBody2D
class_name Enemy

const ENEMY_SHOT = preload ("res://enemy/enemy_shot.tscn")
@export var world : World

@export var max_speed := 500.0
@export var acceleration := 500.0
@export var angular_velocity := 1 * PI
@export var cannon_points: Array[Node2D] = []

@export_subgroup("Drops")
@export var drop_mineral: Mineral
@export var min_drop_amount: int = 1000
@export var max_drop_amount: int = 4000

var target: Vector2
var shot_count := 0

var is_dead := false

var group: EnemyGroup

var exploration_vector: Vector2:
	get:
		return group.exploration_vector
		
var desired_rotation : Vector2 = Vector2()
var chase_dir := Vector2()

var player: Player:
	get:
		return world.player

@onready var behaviour_tree: BehaviourTree = $BehaviourTree
@onready var enemy_group := get_tree().get_nodes_in_group("enemy")

func _ready() -> void:
	behaviour_tree.blackboard.set_value("player", world.player)

func _physics_process(delta: float) -> void:
	enemy_group = get_tree().get_nodes_in_group("enemy")
	
	queue_redraw()
	# turn to face the desired angle if not dead
	if not is_dead:
		var rot_delta := clampf((desired_rotation + chase_dir).angle() - rotation, -angular_velocity * delta, angular_velocity * delta)
		rotation = rotation + rot_delta
		desired_rotation = Vector2()
		chase_dir = Vector2()
	
		# accelerate if speed is smaller than max
		velocity += transform.x * acceleration * delta
		velocity = velocity.limit_length(max_speed)

	move_and_slide()

func shoot() -> void:
	# select cannon point
	var cannon := cannon_points[shot_count % cannon_points.size()]
	
	# fire shot
	var new_shot : Node2D = ENEMY_SHOT.instantiate()
	new_shot.global_position = cannon.global_position
	new_shot.player = world.player
	new_shot.set_inherited_velocity(velocity)
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(world.player.global_position)

	$Shots.add_child(new_shot)
	
	$CannonShotSound.play()
	
	shot_count += 1

func _on_health_component_died() -> void:
	if not is_dead:
		is_dead = true
		behaviour_tree.enabled = false
		$Sprite2D.play("death")
		$DeathSound.play()
		$DeathParticles.emitting = true
	
		if world:
			world.spawn_mineral_pickup(global_position, drop_mineral, randi_range(min_drop_amount, max_drop_amount))

func _draw() -> void:
	draw_line(Vector2(), desired_rotation.normalized().rotated(-global_rotation) * 64, Color.GREEN)
	draw_line(Vector2(), velocity.normalized() * 64, Color.RED)
	draw_line(Vector2(), transform.x.rotated(-global_rotation).normalized() * 64, Color.PINK)
	draw_line(Vector2(), chase_dir.rotated(-global_rotation).normalized() * 64, Color.SKY_BLUE)
