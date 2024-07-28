extends CharacterBody2D
class_name Enemy

@export var world: World

@export var max_speed := 500.0
@export var acceleration := 500.0
@export var angular_velocity := 1 * PI
@export var cannon_points: Array[Node2D] = []
@export var enemy_shot_scene: PackedScene
@export var shot_inaccuracy: float = PI / 6
@export var max_local_group_size := 10
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
		
var desired_rotation: Vector2 = Vector2()
var chase_dir := Vector2()

var player: Player:
	get:
		return world.player

var local_group: Array[Enemy] = []

@onready var behaviour_tree: BehaviourTree = $BehaviourTree
@onready var local_group_area: Area2D = $LocalGroupArea

func _ready() -> void:
	behaviour_tree.blackboard.set_value("player", world.player)
	local_group_area.body_entered.connect(_on_local_area_body_entered)
	local_group_area.body_exited.connect(_on_local_area_body_exited)

func _physics_process(delta: float) -> void:
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
	var origin := cannon_points[shot_count % cannon_points.size()]
	
	# fire shot
	var new_shot: Shot = enemy_shot_scene.instantiate()
	new_shot.global_position = origin.global_position
	new_shot.global_rotation = global_rotation
	
	new_shot.inherited_velocity = velocity
	new_shot.set_destination(player.global_position.rotated(randf_range( - shot_inaccuracy, shot_inaccuracy)))
	new_shot.shot_owner = self
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(player)

	$Shots.add_child(new_shot)
	
	$CannonShotSound.play()
	
	shot_count += 1

func die() -> void:
	is_dead = true
	behaviour_tree.enabled = false
	$Sprite2D.play("death")
	$DeathSound.play()
	$DeathParticles.emitting = true

	if world:
		world.spawn_mineral_pickup(global_position, drop_mineral, randi_range(min_drop_amount, max_drop_amount))
	
func _on_health_component_died() -> void:
	if not is_dead:
		die()
func _draw() -> void:
	draw_line(Vector2(), desired_rotation.normalized().rotated( - global_rotation) * 64, Color.GREEN)
	draw_line(Vector2(), velocity.normalized() * 64, Color.RED)
	draw_line(Vector2(), transform.x.rotated( - global_rotation).normalized() * 64, Color.PINK)
	draw_line(Vector2(), chase_dir.rotated( - global_rotation).normalized() * 64, Color.SKY_BLUE)

func _on_local_area_body_entered(body: Node2D) -> void:
	if local_group.size() < max_local_group_size:
		local_group.append(body)

func _on_local_area_body_exited(body: Node2D) -> void:
	if local_group.has(body):
		local_group.erase(body)