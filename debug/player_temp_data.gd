extends VBoxContainer

@export var player: Player

@onready var temp_label: Label = $TempLabel
@onready var temp_delta_label: Label = $"TempDelta Label"

func _physics_process(delta: float) -> void:
	temp_label.text = str("TEMP: ", player.heat_receiver.temperature)
	temp_delta_label.text = str("DELTA: ", player.heat_receiver.get_temp_delta(delta))
