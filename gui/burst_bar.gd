extends HBoxContainer

@export var player: Player
@export var burst_bar_scene : PackedScene 

var bars : Array[TextureProgressBar] = []

@onready var burst_manager: BurstManager = player.burst_manager

func _ready() -> void:
	burst_manager.amount_of_bursts_updated.connect(_on_amount_of_bursts_updated)
	_recreate_burst_bar()

func _recreate_burst_bar() -> void:
	for bar in bars:
		bars.erase(bar)
		bar.queue_free()
		
	for i in range(burst_manager.amount_of_bursts):
		var instance : TextureProgressBar = burst_bar_scene.instantiate()
		instance.ratio = 1.0

		add_child(instance)
		bars.append(instance)

func _physics_process(_delta: float) -> void:
	var available_bursts := burst_manager.get_amount_of_available_bursts()
	for i in range(bars.size()):
		if i == available_bursts:
			bars[i].ratio = 1.0 - burst_manager.burst_cooldown_timer.time_left / burst_manager.burst_cooldown_timer.wait_time
		elif i < available_bursts:
			bars[i].ratio = 1.0
		else:
			bars[i].ratio = 0.0

func _on_amount_of_bursts_updated(_amount: int) -> void:
	_recreate_burst_bar()
