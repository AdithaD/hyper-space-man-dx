extends Node

@export var debug_console: DebugConsole
@export var commands: Array[Command] = []

@export_subgroup("Coupling")
@export var player: Player
@export var world: World

var mineral_map: Dictionary = {}
var upgrade_map: Dictionary = {}

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