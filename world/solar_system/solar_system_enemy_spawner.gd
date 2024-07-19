extends Node2D

@export var enemy_amount_curve: Curve
@export var enemy_scenes: Array[PackedScene]
@export var danger_multipliers : Array[float] = []

var danger_rating : int = 0

@onready var solar_system : SolarSystem = get_parent()
@onready var spawn_timer: Timer = $SpawnTimer
@onready var danger_timer: Timer = $DangerTimer

func _ready() -> void:
	await get_parent().ready
	solar_system.player_interact_area.player_entered.connect(_on_player_entered.unbind(1))
	solar_system.player_interact_area.player_exited.connect(_on_player_exited.unbind(1))

func spawn() -> void:
	var amount_of_enemies := enemy_amount_curve.sample(randf()) * danger_multipliers[danger_rating]
	
	var group := EnemyGroup.new()
	group.home_solar_system = solar_system
	
	add_child(group)
	
	var spawn_point := Vector2(solar_system.size * randf_range(0.6,0.8), 0).rotated(2 * PI * randf())
	for i in range(amount_of_enemies):
		spawn_enemy(group, spawn_point + Vector2(i * 64, 0))

func spawn_enemy(group: EnemyGroup, local_position: Vector2) -> void:
	var enemy: Enemy = enemy_scenes.pick_random().instantiate()
	enemy.group = group
	enemy.world = solar_system.world

	enemy.global_position = global_position + local_position
	group.add_child(enemy)

func _on_player_entered() -> void:
	danger_rating = 0

	spawn_timer.start()
	danger_timer.start()
	
func _on_player_exited() -> void:
	spawn_timer.stop()
	danger_timer.stop()
	
func _on_spawn_timer_timeout() -> void:
	spawn()

func _on_danger_timer_timeout() -> void:
	danger_rating += 1
