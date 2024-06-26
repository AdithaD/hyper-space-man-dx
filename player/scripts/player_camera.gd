extends Camera2D

#Based of the 3.x KidsCanCode implementation -> https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

@export var decay := 0.8 # How quickly shaking will stop [0,1].
@export var max_offset := Vector2(100, 75) # Maximum displacement in pixels.
@export var max_roll := 0.1 # Maximum rotation in radians (use sparingly).
@export var noise: FastNoiseLite # The source of random values.

@export var peek_ahead = 16

var noise_y = 0 # Value used to move through the noise

var trauma := 0.0 # Current shake strength
var trauma_pwr := 3 # Trauma exponent. Use [2,3]

var _noise_offset: Vector2

func _ready():
	randomize()
	noise.seed = randi()

func add_trauma(amount: float):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
  #optional
	elif _noise_offset.x != 0 or _noise_offset.y != 0 or rotation != 0:
		lerp(_noise_offset.x, 0.0, 1)
		lerp(_noise_offset.y, 0.0, 1)
		lerp(rotation, 0.0, 1)
		
	offset = _noise_offset + (global_position.direction_to(get_global_mouse_position()) * peek_ahead)

func shake():
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(0, noise_y)
	_noise_offset.x = max_offset.x * amt * noise.get_noise_2d(1000, noise_y)
	_noise_offset.y = max_offset.y * amt * noise.get_noise_2d(2000, noise_y)
