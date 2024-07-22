extends Node2D

@export var mineral: Mineral
@export var amount: int = 0
@export var circle_color: Color

var _velocity: Vector2 = Vector2()
var world: World

func _ready() -> void:
	$Sprite2D.texture = mineral.mineral_icon

func _physics_process(delta: float) -> void:
	position += _velocity * delta

func _draw() -> void:
	draw_circle(Vector2(), 64, circle_color, false, 4.0)

func _on_player_interact_area_player_entered(player: Player) -> void:
	player.mineral_inventory.add_amount(mineral, amount)
	queue_free()
