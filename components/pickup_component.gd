class_name PickupComponent
extends Node2D

@export var pickup_range: float = 128.0
@export var must_hold_action: bool = true
@export var action: StringName = &"interact"
@export var wait_time: float = 1.0

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var timer = $PickupTimer
@onready var progress_bar = $PickupProgressBar

func _ready() -> void:
	timer.wait_time = wait_time

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		var should_be_held = Input.is_action_pressed(action) or not must_hold_action
		var in_range = global_position.distance_to(player.global_position) < pickup_range
		if not should_be_held or not in_range:
			timer.stop()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(action):
		if global_position.distance_to(player.global_position) < pickup_range and timer.is_stopped():
			timer.start()
			
func connect_to_pickup(callable: Callable):
	timer.timeout.connect(callable)
