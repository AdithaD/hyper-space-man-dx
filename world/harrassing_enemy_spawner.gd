extends Node2D

@export var player: Player
@export var world: World
@export var enemy_scenes: Array[PackedScene]

@export var offset_from_player: float = 4096

@export var min_group_size: int = 2
@export var max_group_size: int = 4
@export var max_alive := 6

var spawn_count := 0

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
func _on_spawn_timer_timeout() -> void:
	var group_size := mini(randi_range(min_group_size, max_group_size), max_alive - spawn_count)
	
	var enemies: Array[Enemy] = []

	for _i in range(group_size):
		var enemy: Enemy = enemy_scenes.pick_random().instantiate()
		enemies.append(enemy)
		enemy.tree_exited.connect(_on_enemy_exited)

	var offset := Vector2(offset_from_player, 0).rotated(randf() * TAU)

	world.spawn_enemy_group(player.global_position + offset, enemies)
	spawn_count += enemies.size()

func _on_enemy_exited() -> void:
	spawn_count -= 1