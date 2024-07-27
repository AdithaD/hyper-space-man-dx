extends StaticBody2D
class_name Asteroid

@export var death_mineral: Mineral
@export var amount: int = 10

@export var debris_scene: PackedScene

var mineable := false

@onready var world: World = get_tree().get_first_node_in_group("world")

@onready var mineable_sprite: Sprite2D = %MineableSprite
@onready var non_mineable_sprite: Sprite2D = %NonMineableSprite

func _ready() -> void:
	if mineable:
		mineable_sprite.show()
		non_mineable_sprite.hide()
	else:
		mineable_sprite.hide()
		non_mineable_sprite.show()

var is_dead: bool:
	get:
		return false

func _on_health_component_died() -> void:
	if mineable:
		world.spawn_mineral_pickup(global_position, death_mineral, amount)
	
	var debris := debris_scene.instantiate()
	debris.global_position = global_position
	world.add_child(debris)
	
	SoundManager.play_sound_and_free(global_position, $DeathSound.stream)
	queue_free()
