extends HeatReceiver
class_name PlayerHeatReceiver

signal limit_exceeded

@export var temperature_limit: float = 100

@export var temperature_loss_rate: float = 10.0

@export var health_component: HealthComponent

@export var damage_per_tick: int = 1

@onready var damage_timer: Timer = $DamageTimer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_exceeded := false

func _physics_process(delta: float) -> void:
	super(delta)
	var loss := temperature_loss_rate * delta
	temperature = max(temperature - loss, 0)
		
	if temperature > temperature_limit and not is_exceeded:
		is_exceeded = true
		damage_timer.start()
		
		limit_exceeded.emit()
	elif is_exceeded and temperature < temperature_limit:
		damage_timer.stop()
		is_exceeded = false
	
func get_frame_temp_delta(delta: float) -> float:
	return _last_gain / delta - temperature_loss_rate
	
func get_ratio() -> float:
	return min(1.0, temperature / temperature_limit)

func _on_damage_timer_timeout() -> void:
	health_component.take_damage(damage_per_tick)
	audio_stream_player.play()
