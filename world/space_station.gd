class_name SpaceStation
extends Node2D

@export var cost_per_unit: float = 10
@export var cost_mineral: Mineral

@export var prompt = "Trade_per unit fuel"

var interact_area:
	get:
		return $PlayerInteractArea
		
func fill(player: Player) -> void:
	var difference = roundi(player.ship_engine.fuel_capacity - player.ship_engine.current_fuel)

	if difference > 0:
		var cost = difference * cost_per_unit
		
		if player.mineral_inventory.has_amount(cost_mineral, cost) and cost > 0:
			player.mineral_inventory.remove_amount(cost_mineral, cost)
			player.ship_engine.fill()
		
		$FillSound.play()
