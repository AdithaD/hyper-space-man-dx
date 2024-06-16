extends CharacterBody2D
class_name Enemy

const ENEMY_SHOT = preload ("res://enemy/enemy_shot.tscn")

@export var max_speed := 500.0
@export var acceleration := 500.0
@export var angular_velocity := 4 * PI
@export var cannon_points: Array[Node2D] = []

@export_subgroup("Drops")
@export var drop_mineral: Mineral
@export var min_drop_amount: int = 1000
@export var max_drop_amount: int = 4000

var target: Vector2
var shot_count = 0

var is_dead = false

var group: EnemyGroup

var exploration_vector: Vector2:
	get:
		return group.exploration_vector

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var behaviour_tree: BehaviourTree = $BehaviourTree
@onready var enemy_group = get_tree().get_nodes_in_group("enemy")

func _ready() -> void:
	behaviour_tree.blackboard.set_value("player", player)
	$PickupComponent.connect_to_pickup(_on_pickup)

func _physics_process(_delta: float) -> void:
	enemy_group = get_tree().get_nodes_in_group("enemy")
	move_and_slide()

func shoot():
	# select cannon point
	var cannon = cannon_points[shot_count % cannon_points.size()]
	
	# fire shot
	var new_shot = ENEMY_SHOT.instantiate()
	new_shot.global_position = cannon.global_position
	
	if new_shot.has_method("set_target"):
		new_shot.set_target(get_global_mouse_position())

	$Shots.add_child(new_shot)
	
	$CannonShotSound.play()
	
	shot_count += 1

func _on_health_component_died() -> void:
	if not is_dead:
		is_dead = true
		behaviour_tree.enabled = false
		$Sprite2D.play("death")
		$DeathSound.play()
		$PickupComponent.enabled = true
	$DeathParticles.emitting = true

func _on_pickup() -> void:
	var amount = randi_range(min_drop_amount, max_drop_amount)
	player.mineral_inventory.add_amount(drop_mineral, amount)
	queue_free()