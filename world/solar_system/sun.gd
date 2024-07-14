extends SolarObject

func init(frames: SpriteFrames, p_solar_name: String, p_mineral_inventory: MineralInventory, new_scale: float=1) -> void:
	super(frames, p_solar_name, p_mineral_inventory, new_scale)
	$HeatEmitter.radius = radius
