extends Control

var space_station: SpaceStation

@onready var repair_task: Control = %RepairTask
@onready var refuel_task: Control = %RefuelTask

func _ready() -> void:
	repair_task.purchased.connect(_on_repair_task_purchased)
	refuel_task.purchased.connect(_on_refuel_task_purchased)

func update() -> void:
	var player: Player = space_station.player
	var repair_deficiency := ceili(player.health_component.maximum_health - player.health_component.current_health)
	_update_task(repair_task, space_station.repair_cost_mineral, space_station.repair_cost_per_stock, repair_deficiency, player.health_component.maximum_health)

	var refuel_deficiency := ceili(player.ship_engine.fuel_capacity - player.ship_engine.current_fuel)
	_update_task(refuel_task, space_station.refuel_cost_mineral, space_station.refuel_cost_per_stock, refuel_deficiency, player.ship_engine.fuel_capacity)

func set_space_station(station: SpaceStation) -> void:
	space_station = station
	update()
#	func update(cost_mineral: Mineral, cost_per_unit: float, deficiency: float, maximum: float, purchasable_amount: int) -> void:
func _update_task(task_gui: Control, cost_mineral: Mineral, cost_per_unit: int, deficiency: int, maximum: float) -> void:
	var purchasable_amount := floori(space_station.player.mineral_inventory.get_amount(cost_mineral) / cost_per_unit)
	task_gui.update(cost_mineral, cost_per_unit, deficiency, maximum, purchasable_amount)

func _on_refuel_task_purchased(amount: int) -> void:
	space_station.refuel(amount)
	update()

func _on_repair_task_purchased(amount: int) -> void:
	space_station.repair(amount)
	update()
