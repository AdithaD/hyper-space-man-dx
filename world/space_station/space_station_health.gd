extends SpaceStation

func fill(player: Player) -> void:
	var hc := player.get_health_component()
	var difference = roundi(hc.maximum_health - hc.current_health)

	if difference > 0:
		var cost = difference * cost_per_unit
		
		if player.mineral_inventory.has_amount(cost_mineral, cost) and cost > 0:
			player.mineral_inventory.remove_amount(cost_mineral, cost)
			hc.heal(difference)
		
		$FillSound.play()
