extends Control



func _on_player_fuel_changed(_new_amount: int, ratio: float) -> void:
	%FuelGauge.ratio = ratio
	pass # Replace with function body.


func _on_player_heat_changed(_new_amount: int, ratio: float) -> void:
	%WeaponHeatGauge.ratio = ratio
	pass # Replace with function body.
