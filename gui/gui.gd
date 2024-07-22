extends Control

@export var player: Player
@export var world: World

@export var low_fuel_threshold: float = 0.25

@onready var upgrade_screen: Control = %UpgradeScreen

@onready var solar_object_panel: Control = %SolarObjectPanel

@onready var prompt: Control = %Prompt

@onready var speed_bar: TextureProgressBar = %SpeedBar
@onready var speed_label: Label = %SpeedLabel
@onready var overspeed_caution_label: Label = %OverspeedCautionLabel
@onready var destruction_timer_label: Label = %DestructionTimerLabel
@onready var overheat_caution_label: Label = %OverheatCautionLabel

@onready var fuel_bar: Control = %FuelBar
@onready var hull_bar: Control = %HullBar
@onready var temperature_bar: Control = %TemperatureBar

@onready var anti_gravity_label: Label = %AntiGravityLabel

@onready var weapon_heat_gauge: Control = %WeaponHeatGauge

@onready var lock_acquired_label: Label = %LockAcquiredLabel
@onready var no_lock_label: Label = %NoLockLabel

@onready var warning_sound: AudioStreamPlayer = $WarningSound
@onready var low_fuel_label: Label = %LowFuelLabel

func _ready() -> void:
	player.ship_engine.engine_burned.connect(_on_player_engine_burned)
	player.player_state_changed.connect(_on_player_state_changed)
	player.health_component.health_changed.connect(_on_player_health_changed)
	player.mining_interactor.stack_changed.connect(solar_object_panel._on_player_mining_interactor_stack_changed)
	
	# Prompt
	world.solar_system_spawner.solar_system_spawned.connect(prompt.update.unbind(1))
	world.mining_drone_created.connect(prompt.update.unbind(1))
	
	#intiial state
	fuel_bar.set_ratio(player.ship_engine.get_ratio())
	anti_gravity_label.enabled = player.is_anti_gravity_on
	weapon_heat_gauge.set_ratio(0.0)
	
func _on_player_state_changed(is_anti_gravity_on: bool) -> void:
	anti_gravity_label.enabled = is_anti_gravity_on
	
func _on_player_engine_burned(_new_amount: int, ratio: float) -> void:
	fuel_bar.set_ratio(ratio)

func _on_player_heat_changed(_new_amount: int, ratio: float) -> void:
	weapon_heat_gauge.set_ratio(ratio)
	weapon_heat_gauge.set_overheat_mode(player.is_overheated)

func _physics_process(_delta: float) -> void:
	var speed_ratio := player.velocity.length() / player.max_speed
	speed_bar.value = speed_ratio * 100
	speed_label.text = str(GlobalFormat.format_amount(floori(player.velocity.length())))
	
	overspeed_caution_label.visible = player.is_overspeed
	destruction_timer_label.visible = player.is_overspeed
	
	overheat_caution_label.visible = player.heat_receiver.is_exceeded
	
	low_fuel_label.visible = player.ship_engine.current_fuel / player.ship_engine.fuel_capacity < low_fuel_threshold
	
	if player.is_overspeed:
		destruction_timer_label.text = "Estimated destruction in %1.1fs" % player.overspeed_timer.time_left

		if not warning_sound.playing:
			warning_sound.play()
	else:
		if warning_sound.playing:
			warning_sound.stop()
	
	temperature_bar.set_ratio(player.heat_receiver.get_ratio())

func _on_player_health_changed(_amount: int, health: int, maximum_health: int) -> void:
	hull_bar.segments = maximum_health
	hull_bar.value = health
	hull_bar.queue_redraw()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("toggle_upgrade_screen"):
		upgrade_screen.visible = not upgrade_screen.visible
		player.has_control = not upgrade_screen.visible
