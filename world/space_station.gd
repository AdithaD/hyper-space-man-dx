class_name SpaceStation
extends Node2D

@export var repair_cost_per_stock: int = 10
@export var repair_cost_mineral: Mineral

@export var refuel_cost_per_stock: int = 10
@export var refuel_cost_mineral: Mineral

@export var prompt := "Trade_per unit fuel"

@export var orbit_speed := 300.0
var orbit_origin: Vector2

var last_velocity := Vector2.ZERO

var interact_area: PlayerInteractArea:
	get:
		return $PlayerInteractArea

var player: Player

func _ready() -> void:
	interact_area.player_entered.connect(func(p: Player) -> void: player=p)
	interact_area.player_exited.connect(func(_p: Player) -> void: player=null)

func _physics_process(delta: float) -> void:
	if orbit_origin:
		var dir := global_position.direction_to(orbit_origin).normalized().orthogonal()
		last_velocity = dir * orbit_speed * delta
		position += last_velocity

	queue_redraw()

func refuel(stock: int) -> void:
	_do_action(stock, refuel_cost_mineral, refuel_cost_per_stock, player.ship_engine.fill)
	
func repair(stock: int) -> void:
	_do_action(stock, repair_cost_mineral, repair_cost_per_stock, player.health_component.heal)

func can_refuel(stock: int) -> bool:
	return can_do_action(stock, refuel_cost_mineral, refuel_cost_per_stock)

func can_repair(stock: int) -> bool:
	return can_do_action(stock, repair_cost_mineral, repair_cost_per_stock)

func _do_action(stock: int, cost_mineral: Mineral, cost_per_stock: int, callback: Callable, unit: int=1) -> void:
	if player.mineral_inventory.has_amount(cost_mineral, stock * cost_per_stock) and stock > 0:
		player.mineral_inventory.remove_amount(cost_mineral, stock * cost_per_stock)
		callback.call(stock * unit)
		$FillSound.play()

func can_do_action(stock: int, cost_mineral: Mineral, cost_per_stock: int) -> bool:
	var cost := stock * cost_per_stock
	return player.mineral_inventory.has_amount(cost_mineral, cost) and cost > 0.0