extends Resource
class_name Command

enum ArgumentType {
	STRING, NUMBER, MINERAL, UPGRADE, COMMAND, BOOLEAN
}

@export var name: String
@export var description: String

@export var arguments: Array[ArgumentType] = []

func is_valid(p_arguments: Array) -> bool:
	# validate arguments
	for i in range(arguments.size()):
		var type: ArgumentType = arguments[i]
		var argument: Variant = p_arguments[i]
		prints(type, argument)
		match type:

			ArgumentType.STRING:
				if not argument is String:
					return false

			ArgumentType.NUMBER:
				if not argument is int and not argument is float:
					return false

			ArgumentType.MINERAL:
				if not argument is Mineral:
					return false

			ArgumentType.UPGRADE:
				if not argument is TieredUpgrade:
					return false

			ArgumentType.BOOLEAN:
				if not argument is bool:
					return false

	return arguments.size() == p_arguments.size()
