extends Node
class_name BurstManager

signal amount_of_bursts_updated(new_amount: int)

@export var burst_impulse: float = 500
@export var amount_of_bursts: int = 3
@export var burst_coolodown: float = 5.0
@export var burst_fuel_consumption: float = 10.0

@onready var _available_bursts := amount_of_bursts

@onready var player: Player = get_parent()
@onready var burst_cooldown_timer: Timer = $BurstCooldownTimer
@onready var burst_particles_left: GPUParticles2D = $BurstParticlesLeft
@onready var burst_particles_right: GPUParticles2D = $BurstParticlesRight
@onready var burst_particles_front: GPUParticles2D = $BurstParticlesFront
@onready var burst_particles_back: GPUParticles2D = $BurstParticlesBack
@onready var burst_sound: AudioStreamPlayer2D = $BurstSound

func _ready() -> void:
	burst_cooldown_timer.timeout.connect(_on_timer_timeout)
	
func notify(left: bool, right: bool, forward: bool, backward: bool) -> void:
	var bursted := left or right or forward or backward
	if is_burst_available() and bursted:
		if left:
			player.apply_impulse(Vector2.UP * burst_impulse)
			burst_particles_right.emitting = true
		elif right:
			player.apply_impulse(Vector2.DOWN * burst_impulse)
			burst_particles_left.emitting = true
		elif forward:
			player.apply_impulse(Vector2.RIGHT * burst_impulse)
			burst_particles_back.emitting = true
		elif backward:
			player.apply_impulse(Vector2.LEFT * burst_impulse)
			burst_particles_front.emitting = true

		player.ship_engine.burn_amount(burst_fuel_consumption)

		burst_sound.play()
		
		_available_bursts -= 1
	
		if burst_cooldown_timer.is_stopped():
			burst_cooldown_timer.start()

func set_burst_amount(new_amount: int) -> void:
	amount_of_bursts = new_amount
	_available_bursts = min(_available_bursts, amount_of_bursts)
	
	amount_of_bursts_updated.emit(new_amount)

func _on_timer_timeout() -> void:
	_available_bursts += 1
	if _available_bursts < amount_of_bursts:
		burst_cooldown_timer.start()

func is_burst_available() -> bool:
	return _available_bursts > 0 and player.ship_engine.current_fuel > burst_fuel_consumption

func get_amount_of_available_bursts() -> int:
	return _available_bursts
