class_name SpaceStation
extends Node2D

@export var cost_per_unit: float = 10
@export var cost_mineral: Mineral

var interact_area:
	get:
		return $PlayerInteractArea