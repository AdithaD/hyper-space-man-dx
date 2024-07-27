extends Node

@export var debug_console: DebugConsole
@export var commands: Array[Command] = []

@export_subgroup("Coupling")
@export var player: Player
@export var world: World
@export var enemy_parent: Node2D

var mineral_map: Dictionary = {}
var upgrade_map: Dictionary = {}

@export var debug_enemy_scenes: Array[PackedScene]

func _ready() -> void:
	debug_console.command_submitted.connect(_on_command_submitted)
	debug_console.set_commands(commands)

	for m in world.minerals:
		mineral_map[m.mineral_id.to_lower()] = m

	debug_console.mineral_map = mineral_map

	for u in player.upgrades:
		upgrade_map[u.upgrade_id.to_lower()] = u

	debug_console.upgrade_map = upgrade_map

func _on_command_submitted(command: Command, arguments: Array) -> void:
	match command.name:
		"give":
			_give_command_handler(arguments)
		"level":
			_level_command_handler(arguments)
		"killall":
			_killall_command_handler()
		"heal":
			_heal_command_handler(arguments)
		"damage":
			_damage_command_handler(arguments)
		"set_invincible":
			_set_invincible_command_handler(arguments)
		"spawn_enemy":
			_spawn_enemy_command_handler(arguments)
		_:
			print_debug("Command not found")

func _give_command_handler(arguments: Array) -> void:
	var mineral: Mineral = arguments[0]
	var amount: int = arguments[1]

	if not mineral:
		print_debug("Mineral not found")
	else:
		player.mineral_inventory.add_amount(mineral, amount)

func _level_command_handler(arguments: Array) -> void:
	var upgrade: TieredUpgrade = arguments[0]
	
	if upgrade:
		player.apply_upgrade(upgrade, true, true)

func _killall_command_handler() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.die()
		
func _heal_command_handler(arguments: Array) -> void:
	var amount: int = arguments[0]

	player.health_component.heal(amount)

func _damage_command_handler(arguments: Array) -> void:
	var amount: int = arguments[0]

	player.health_component.take_damage(amount)
	
func _set_invincible_command_handler(arguments: Array) -> void:
	var invincible: bool = arguments[0]

	player.health_component.invincible = invincible

func _spawn_enemy_command_handler(arguments: Array) -> void:
	var amount: int = arguments[0]
	
	var group: EnemyGroup = EnemyGroup.new()

	for _i in range(amount):
		var enemy: Enemy = debug_enemy_scenes.pick_random().instantiate()
		enemy.position = (Vector2.RIGHT * 100).rotated(randf() * TAU)
		enemy.world = world
		enemy.group = group
		group.add_child(enemy)

	enemy_parent.add_child(group)
