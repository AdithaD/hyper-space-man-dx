extends Resource
class_name ShipEngine

signal engine_burned(current_fuel : float, fuel_ratio : float)

@export var exhaust_velocity := 1.0

@export var dry_mass := 5.0
# fuel weight in kilos
@export var fuel_capacity : float = 100.0

@export var mass_flow_rate : float = 1.0

var current_fuel := 0.0:
	set(value):
		current_fuel = clamp(value, 0, fuel_capacity)

func _init(p_exhaust_velocity : float = 1.0, p_mass_flow_rate : float = 1.0, p_dry_mass : float = 5.0, p_fuel_capacity : float = 100.0) -> void:
	exhaust_velocity = p_exhaust_velocity
	dry_mass = p_dry_mass
	fuel_capacity = p_fuel_capacity
	mass_flow_rate = p_mass_flow_rate
	
	current_fuel = fuel_capacity

# conservation of momentum
func burn(delta: float, direction: Vector2) -> Vector2:
	var amount_of_mass_expelled := clampf(mass_flow_rate * delta, 0.0, current_fuel)
	
	current_fuel -= amount_of_mass_expelled
	
	var change_in_velocity = amount_of_mass_expelled * exhaust_velocity / (dry_mass + current_fuel)
	
	engine_burned.emit(current_fuel, current_fuel / fuel_capacity)
	return change_in_velocity * direction
