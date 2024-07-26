extends Control

var space_station: SpaceStation

@onready var repair_task: Control = %RepairTask
@onready var refuel_task: Control = %RefuelTask

func update() -> void:
	var player: Player = space_station.player
	var repair_deficiency := ceili(player.health_component.maximum_health - player.health_component.current_health)
	_update_task(repair_task, space_station.repair_cost_mineral, space_station.repair_cost_per_unit, repair_deficiency)

	var refuel_deficiency := ceili(player.ship_engine.fuel_capacity - player.ship_engine.current_fuel)
	_update_task(refuel_task, space_station.refuel_cost_mineral, space_station.refuel_cost_per_unit, refuel_deficiency)

func set_space_station(station: SpaceStation) -> void:
	space_station = station

	update()
	
func _update_task(task_gui: Control, cost_mineral: Mineral, cost_per_unit: int, deficiency: int) -> void:
	task_gui.set_cost(cost_mineral, cost_per_unit)
	var purchasable_amount := floori(space_station.player.mineral_inventory.get_amount(cost_mineral) / cost_per_unit)
	task_gui.update(deficiency, purchasable_amount)

func _on_refuel_task_single_task_purchased() -> void:
	space_station.refuel(1)
	update()

func _on_refuel_task_all_task_purchased() -> void:
	space_station.refuel_all()
	update()

func _on_repair_task_single_task_purchased() -> void:
	space_station.repair(1)
	update()

func _on_repair_task_all_task_purchased() -> void:
	space_station.repair_all()
	update()