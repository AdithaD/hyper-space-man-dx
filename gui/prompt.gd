extends Control

signal prompt_interacted(object: Object)

# multiple prompts may need to shown at the same time.
# this maintains a stack showing the most recent one first.
var stack := []

func _ready() -> void:
	update()

func connect_to_space_station(ss: SpaceStation) -> void:
	_bind_to_player(ss, show_trade_prompt.bind(ss))

func connect_to_mining_drone(ma: MiningDrone) -> void:
	_bind_to_player(ma, show_mining_drone_prompt.bind(ma))

func _bind_to_player(object: Node2D, entered_callable: Callable) -> void:
	var ia : PlayerInteractArea = object.interact_area
	if not ia.player_entered.is_connected(entered_callable.unbind(1)):
		ia.player_entered.connect(entered_callable.unbind(1))

	var exit_callable := pop.bind(object)
	if not ia.player_exited.is_connected(exit_callable.unbind(1)):
		ia.player_exited.connect(exit_callable.unbind(1))

func show_trade_prompt(space_station: SpaceStation) -> void:
	#add to stack
	push(space_station, %TradePrompt)
	
	var sections := space_station.prompt.split("_")

	%PreCostTextLabel.text = sections[0]
	%PostCostTextLabel.text = sections[1]

	%TradeCostLabel.text = str(space_station.cost_per_unit)
	%TradeMineralTextureRect.texture = space_station.cost_mineral.mineral_icon
	hide_all_except( %TradePrompt)

func show_mining_drone_prompt(mining_drone: MiningDrone) -> void:
	#add to stack
	push(mining_drone, %MiningDronePrompt)
	hide_all_except(%MiningDronePrompt)

func hide_all_except(child: Control) -> void:
	for c in get_children():
		c.hide()
	
	child.show()

func push(source: Object, element: Control) -> void:
	stack.append({"source": source, "element": element})

func pop(source: Object) -> void:
	for item : Dictionary in stack:
		if item["source"] == source:
			item["element"].hide()
			stack.erase(item)
			break
	
	if not stack.is_empty():
		var back : Dictionary = stack.back()
		back["source"].show()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not stack.is_empty():
			prompt_interacted.emit(stack.back()["source"])
		
func update() -> void:
	var space_stations := get_tree().get_nodes_in_group("space_station")
	for ss in space_stations:
		connect_to_space_station(ss as SpaceStation)
	
	var mining_drones := get_tree().get_nodes_in_group("mining_drone")
	for ma in mining_drones:
		connect_to_mining_drone(ma as MiningDrone)
