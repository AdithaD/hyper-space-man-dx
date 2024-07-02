extends Control

@export var player: Player
@export var world: World

func _ready() -> void:
	player.ship_engine.engine_burned.connect(_on_player_engine_burned)
	player.player_state_changed.connect(_on_player_state_changed)
	player.get_health_component().health_changed.connect(_on_player_health_changed)
	player.mining_interactor.stack_changed.connect(%SolarObjectPanel._on_player_mining_interactor_stack_changed)
	
	# Prompt
	%SolarSystemSpawner.solar_system_spawned.connect( %Prompt.update.unbind(1))
	world.mining_drone_created.connect( %Prompt.update.unbind(1))
	
	#intiial state
	%FuelBar.set_ratio(player.ship_engine.get_ratio())
	%AntiGravityLabel.enabled = player.is_anti_gravity_on
	%WeaponHeatGauge.set_ratio(0.0)
	
func _on_player_state_changed(is_anti_gravity_on: bool) -> void:
	%AntiGravityLabel.enabled = is_anti_gravity_on
	
func _on_player_engine_burned(_new_amount: int, ratio: float) -> void:
	%FuelBar.set_ratio(ratio)

func _on_player_heat_changed(_new_amount: int, ratio: float) -> void:
	%WeaponHeatGauge.set_ratio(ratio)
	%WeaponHeatGauge.set_overheat_mode(player.is_overheated)

func _physics_process(_delta: float) -> void:
	var speed_ratio := player.velocity.length() / player.max_speed
	%SpeedBar.value = speed_ratio * 100
	%SpeedLabel.text = str(format_amount(player.velocity.length()))
	
	%OverspeedCautionLabel.visible = player.is_overspeed
	%DestructionTimerLabel.visible = player.is_overspeed
	if player.is_overspeed:
		%DestructionTimerLabel.text = "Estimated destruction in %1.1fs" % player.overspeed_timer.time_left

		if not $WarningSound.playing:
			$WarningSound.play()
	else:
		if $WarningSound.playing:
			$WarningSound.stop()

func _on_player_health_changed(_amount : int, health : int, maximum_health : int) -> void:
	%HullBar.segments = maximum_health
	%HullBar.value = health
	%HullBar.queue_redraw()

func _unhandled_key_input(event : InputEvent) -> void:
	if event.is_action_released("toggle_upgrade_screen"):
		$UpgradeScreen.visible = not $UpgradeScreen.visible
		player.has_control = not $UpgradeScreen.visible

func format_amount(amount : int) -> String:
	var pow := log(amount) / log(10)
	var suffix := ""
	if pow >= 3:
		suffix = "K"
	elif pow >= 6:
		suffix = "M"
	
	var quotient : float = amount if pow < 3 else amount / pow(10, floori(pow/3) * 3)
	return ("%.1f%s" if pow > 3 else "%.0f%s") % [quotient, suffix]
