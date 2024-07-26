class_name SpaceStation
extends Node2D

@export var repair_cost_per_unit: int = 10
@export var repair_cost_mineral: Mineral

@export var refuel_cost_per_unit: int = 10
@export var refuel_cost_mineral: Mineral

@export var prompt := "Trade_per unit fuel"

@export var orbit_speed := 300.0
var orbit_origin: Vector2

var interact_area: PlayerInteractArea:
	get:
		return $PlayerInteractArea

var player: Player

func _ready() -> void:
	interact_area.player_entered.connect(func(p: Player) -> void: player=p)
	interact_area.player_exited.connect(func(_p: Player) -> void: player=null)

func _physics_process(delta: float) -> void:
	var dir := global_position.direction_to(orbit_origin).normalized().orthogonal()
	position += dir * orbit_speed * delta
	queue_redraw()

func refuel(amount: int) -> void:
	_do_action(amount, refuel_cost_mineral, refuel_cost_per_unit, player.ship_engine.fill)
	
func refuel_all() -> void:
	var difference := roundi(player.ship_engine.fuel_capacity - player.ship_engine.current_fuel)
	refuel(difference)

func repair(amount: int) -> void:
	_do_action(amount, repair_cost_mineral, repair_cost_per_unit, player.health_component.heal)

func repair_all() -> void:
	var difference := roundi(player.health_component.maximum_health - player.health_component.current_health)
	repair(difference)

func can_refuel(amount: int) -> bool:
	return can_do_action(amount, refuel_cost_mineral, refuel_cost_per_unit)

func can_repair(amount: int) -> bool:
	return can_do_action(amount, repair_cost_mineral, repair_cost_per_unit)

func _do_action(amount: int, cost_mineral: Mineral, cost_per_unit: int, callback: Callable) -> void:
	if player.mineral_inventory.has_amount(cost_mineral, amount * cost_per_unit) and amount > 0:
		player.mineral_inventory.remove_amount(cost_mineral, amount * cost_per_unit)
		callback.call(amount)
		$FillSound.play()

func can_do_action(amount: int, cost_mineral: Mineral, cost_per_unit: int) -> bool:
	var cost := amount * cost_per_unit
	return player.mineral_inventory.has_amount(cost_mineral, cost) and cost > 0.0