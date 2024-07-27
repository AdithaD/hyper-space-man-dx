extends RayCast2D
class_name WeaponRaycaster

signal target_hit(hurtbox: HurtboxComponent)

@export var ray_distance := 1000.0
@export var ray_color: Color
@export var ray_width: float

var weapon: PlayerWeapon
var is_shooting := false

@onready var hit_timer := $HitTimer
@onready var startup_timer := $StartupTimer

@onready var laser_build_sound: AudioStreamPlayer = $LaserBuildSound
@onready var laser_beam_sound: AudioStreamPlayer = $LaserBeamSound

func _ready() -> void:
	startup_timer.timeout.connect(_enable_shooting)

func _physics_process(_delta: float) -> void:
	if is_shooting:
		var collider := get_collider()
		
		if collider is HurtboxComponent:
			if hit_timer.is_stopped():
				hit_timer.start()
				target_hit.emit(collider)

		target_position = Vector2.RIGHT * ray_distance
		queue_redraw()

func _draw() -> void:
	if is_shooting:
		var destination := target_position if not is_colliding() else to_local(get_collision_point())
		draw_line(Vector2.ZERO, destination, ray_color, ray_width)

func start_shooting(player_weapon: PlayerWeapon) -> void:
	if not is_shooting and startup_timer.is_stopped():
		weapon = player_weapon
		
		hit_timer.wait_time = weapon.shot_cooldown
		startup_timer.start()
		laser_build_sound.play()

func _enable_shooting() -> void:
	is_shooting = true

	laser_build_sound.stop()
	laser_beam_sound.play()

func stop_shooting() -> void:
	is_shooting = false
	startup_timer.stop()
	
	laser_build_sound.stop()
	laser_beam_sound.stop()
	queue_redraw()
