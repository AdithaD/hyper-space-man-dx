extends Control

@export var player : Player

func _ready() -> void:
	player.ship_engine.engine_burned.connect(_on_player_engine_burned)

func _on_player_engine_burned(_new_amount: int, ratio: float) -> void:
	%FuelGauge.ratio = ratio

func _on_player_heat_changed(_new_amount: int, ratio: float) -> void:
	%WeaponHeatGauge.ratio = ratio

func _physics_process(delta: float) -> void:
	var speed_ratio = player.velocity.length() / player.max_speed
	%SpeedGauge.set_ratio(speed_ratio)
	
	if speed_ratio > 1.0:
		if not $WarningSound.playing:
			$WarningSound.play()
	else:
		if $WarningSound.playing:
			$WarningSound.stop()
