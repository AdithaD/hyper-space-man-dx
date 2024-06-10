extends Node

@onready var player: Player = $Player
@onready var world: World = $World

func _ready() -> void:
	world.configure_player(player)
	world.start()

func _on_prompt_prompt_interacted(object: Object) -> void:
	if object is SpaceStation:
		var space_station = object as SpaceStation
		var difference = roundi(player.ship_engine.fuel_capacity - player.ship_engine.current_fuel)
		var cost = difference * space_station.cost_per_unit
		
		if player.mineral_inventory.has_amount(space_station.cost_mineral, cost) and cost > 0:
			player.mineral_inventory.remove_amount(space_station.cost_mineral, cost)
			player.ship_engine.fill()
