extends Shot
class_name MultiCannonShot

@export var cannon_shot_scene: PackedScene
@export var arc_angle: float = PI / 3
@export var amount := 5

var damage := 1

func _ready() -> void:
	shoot()
	queue_free()

func shoot() -> void:
	# instance multiple cannon shots spread evenly within an arc centered in the forward direction and add them all as children
	for i in range(amount):
		var new_shot: Shot = cannon_shot_scene.instantiate()
		new_shot.global_position = global_position
		
		new_shot.set_destination(global_position + transform.x.rotated(lerp( - arc_angle, arc_angle, i / float(amount))))
		new_shot.set_damage(damage)
		new_shot.inherited_velocity = inherited_velocity
	
		add_sibling(new_shot)

func set_damage(new_damage: int) -> void:
	self.damage = new_damage