extends Control
class_name DebugConsole

signal command_submitted(command: Command, arguments: Array)

@export var player: Player

var _command_map: Dictionary = {}
var mineral_map: Dictionary = {}
var upgrade_map: Dictionary = {}

var history: Array[CommandCall] = []

var _history_index := 0

@onready var command_line_edit: LineEdit = %CommandLineEdit
@onready var output_text_label: RichTextLabel = %OutputTextLabel

func _ready() -> void:
	command_line_edit.text_submitted.connect(_on_command_submitted)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		visible = not visible
		player.has_control = not visible

		if visible:
			command_line_edit.grab_focus()
		else:
			command_line_edit.release_focus()

	if event.is_action_pressed("debug_history_up"):
		if history.size() > _history_index:
			_history_index += 1
			command_line_edit.text = history[- _history_index].input

	if event.is_action_pressed("debug_history_down"):
		if history.size() > _history_index - 1:
			_history_index -= 1

			if _history_index > 0:
				command_line_edit.text = history[- _history_index].input
			else:
				command_line_edit.text = ""

func set_commands(commands: Array[Command]) -> void:
	_command_map.clear()
	for command in commands:
		_command_map[command.name] = command

func _on_command_submitted(input: String) -> void:
	var split := input.strip_edges().split(" ")

	var command: Command = _command_map.get(split[0])
	
	if not command:
		push_output("[color=#FF6347]Command not found[/color]")
		return

	var arguments: Array = []
	
	if split.size() > 1:
		var raw_arguments := split.slice(1)
		if raw_arguments.size() != command.arguments.size():
			push_output("[color=#FF6347]Invalid argument count[/color]")
			return
			
		arguments = _map_arguments(command, raw_arguments)

		if not command.is_valid(arguments):
			push_output("[color=#FF6347]Invalid arguments[/color]")
			return

	command_submitted.emit(command, arguments)

	var new_call := CommandCall.new(command, arguments, input)
	history.append(new_call)

	push_output("[color=#ADFF2F]>>%s[/color]" % input)
	_history_index = 0

func push_output(output: String) -> void:
	output_text_label.append_text(output + "\n")
	command_line_edit.clear()

func _map_arguments(command: Command, arguments: Array) -> Array:
	var mapped_arguments := []

	for i in range(arguments.size()):
		var type: Command.ArgumentType = command.arguments[i]
		var argument: Variant = arguments[i]

		match type:
			Command.ArgumentType.STRING:
				mapped_arguments.append(argument)

			Command.ArgumentType.NUMBER:
				mapped_arguments.append(float(argument))

			Command.ArgumentType.MINERAL:
				mapped_arguments.append(mineral_map.get(argument.to_lower()))

			Command.ArgumentType.UPGRADE:
				mapped_arguments.append(upgrade_map.get(argument.to_lower()))
			
			Command.ArgumentType.BOOLEAN:
				if argument in ["true", "yes", "y"]:
					mapped_arguments.append(true)
				elif argument in ["false", "no", "n"]:
					mapped_arguments.append(false)
				else:
					mapped_arguments.append(null)

	return mapped_arguments

class CommandCall:
	var command: Command
	var arguments: Array
	var input: String
	
	func _init(p_command: Command, p_arguments: Array=[], p_input: String="") -> void:
		command = p_command
		arguments = p_arguments
		input = p_input
