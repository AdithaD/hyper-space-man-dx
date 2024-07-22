class_name MiningDrone
extends Node2D

signal pickup
signal harvested(assortment: Dictionary)

@export var harvest_rate: int = 100

@export var maximum_storage: int = 3000

@export var pickup_radius := 100.0

var is_broken := false

var interact_area: PlayerInteractArea:
	get:
		return $PlayerInteractArea

var mineral_inventory: MineralInventory = MineralInventory.new()

var mine_target: SolarObject

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_component: PickupComponent = $PickupComponent
@onready var mine_tick_timer: Timer = $MineTickTimer
@onready var mineral_inventory_gui: VBoxContainer = %MineralInventoryGUI

func _ready() -> void:
	activate()
	
	mineral_inventory_gui.set_mineral_inventory(mineral_inventory)
	pickup_component.connect_to_pickup(pickup.emit)
	mine_tick_timer.timeout.connect(do_mine_tick)

func activate() -> void:
	sprite.rotation_enabled = false
	sprite.play("startup")
	
	await sprite.animation_finished
	
	sprite.play("active")
	sprite.rotation_enabled = true
	mine_tick_timer.start()

func deactivate() -> void:
	mine_tick_timer.stop()
	sprite.rotation_enabled = false
	sprite.stop()

func do_mine_tick() -> void:
	# get assortment
	var assortment := mine_target.mineral_inventory.generate_assortment(harvest_rate)

	for mineral : Mineral in assortment.keys():
		var amount : int = assortment[mineral]
		var total := mineral_inventory.get_total_minerals()
		if total + amount > maximum_storage:
			amount = maximum_storage - total

		mine_target.mineral_inventory.remove_amount(mineral, assortment[mineral])
		mineral_inventory.add_amount(mineral, assortment[mineral])

	if mineral_inventory.get_total_minerals() >= maximum_storage:
		deactivate()

	print(assortment)
	harvested.emit(assortment)

func _on_health_component_died() -> void:
	$DeathParticles.emitting = true
	sprite.rotation_enabled = false
	sprite.stop()
	
	is_broken = true
	mineral_inventory = MineralInventory.new()

func _on_health_component_health_changed(_amount: int, health: int, maximum_health: int) -> void:
	%HealthBar.segments = maximum_health
	%HealthBar.value = health

func set_mine_target(target: SolarObject) -> void:
	mine_target = target
