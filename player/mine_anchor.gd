class_name MineAnchor
extends Node2D

signal pickup
signal harvested(assortment: Dictionary)

@export var harvest_rate: int = 100
@export var maximum_storage: int = 3000

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_timer: Timer = $PickupTimer
@onready var mine_tick_timer: Timer = $MineTickTimer

var is_broken = false

var interact_area:
	get:
		return $PlayerInteractArea

var mineral_inventory: MineralInventory = MineralInventory.new()

var mine_target: SolarObject

func _ready() -> void:
	activate()
	
	$MineralInventoryGUI.set_mineral_inventory(mineral_inventory)

	pickup_timer.timeout.connect(pickup.emit)

	mine_tick_timer.timeout.connect(do_mine_tick)
	
func _process(_delta: float) -> void:
	if not pickup_timer.is_stopped() and not Input.is_action_pressed("mine"):
		pickup_timer.stop()

func activate():
	sprite.rotation_enabled = false
	sprite.play("startup")
	
	await sprite.animation_finished
	
	sprite.play("active")
	sprite.rotation_enabled = true
	mine_tick_timer.start()

func deactivate():
	mine_tick_timer.stop()
	sprite.rotation_enabled = false
	sprite.stop()

func do_mine_tick():
	# get assortment
	var assortment = mine_target.mineral_inventory.generate_assortment(harvest_rate)

	for mineral in assortment.keys():
		var amount = assortment[mineral]
		var total = mineral_inventory.get_total_minerals()
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

func start_pickup_timer():
	$PickupTimer.start()

func _on_health_component_health_changed(_amount: int, health: int, maximum_health: int) -> void:
	%HealthBar.segments = maximum_health
	%HealthBar.value = health

func set_mine_target(target: SolarObject):
	mine_target = target
