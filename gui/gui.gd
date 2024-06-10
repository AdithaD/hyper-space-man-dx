extends Control

@export var player: Player
@export var world: World

func _ready() -> void:
	player.ship_engine.engine_burned.connect(_on_player_engine_burned)
	player.player_state_changed.connect(_on_player_state_changed)
	player.get_health_component().health_changed.connect(_on_player_health_changed)
	player.mining_interactor.stack_changed.connect( %SolarMineralInventoryGUI._on_player_mining_interactor_stack_changed)
	
	# Prompt
	%SolarSystemSpawner.solar_system_spawned.connect( %Prompt.update.unbind(1))
	world.mine_anchor_created.connect( %Prompt.update.unbind(1))
	
	#intiial state
	%FuelGauge.ratio = player.ship_engine.get_ratio()
	
func _on_player_state_changed(is_anti_gravity_on: bool) -> void:
	%AntiGravityButton.button_pressed = is_anti_gravity_on
	
func _on_player_engine_burned(_new_amount: int, ratio: float) -> void:
	%FuelGauge.ratio = ratio

func _on_player_heat_changed(_new_amount: int, ratio: float) -> void:
	%WeaponHeatGauge.ratio = ratio

func _physics_process(_delta: float) -> void:
	var speed_ratio = player.velocity.length() / player.max_speed
	%SpeedGauge.set_ratio(speed_ratio)
	
	%OverspeedCautionLabel.visible = player.is_overspeed
	%DestructionTimerLabel.visible = player.is_overspeed
	if player.is_overspeed:
		%DestructionTimerLabel.text = "Estimated destruction in %1.1fs" % player.overspeed_timer.time_left

		if not $WarningSound.playing:
			$WarningSound.play()
	else:
		if $WarningSound.playing:
			$WarningSound.stop()

func _on_player_health_changed(_amount, health, maximum_health):
	%PlayerHealthBar.segments = maximum_health
	%PlayerHealthBar.value = health
	%PlayerHealthBar.queue_redraw()
