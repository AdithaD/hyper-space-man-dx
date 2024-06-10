extends Control

signal prompt_interacted(object: Object)

# multiple prompts may need to shown at the same time.
# this maintains a stack showing the most recent one first.
var stack = []

func _ready() -> void:
	var space_stations = get_tree().get_nodes_in_group("space_station")
	for ss in space_stations:
		connect_to_space_station(ss)
	
	var mine_anchors = get_tree().get_nodes_in_group("mine_anchor")
	for ma in mine_anchors:
		connect_to_mine_anchor(ma)

func connect_to_space_station(ss: SpaceStation) -> void:
	ss.interact_area.player_entered.connect(show_trade_prompt.bind(ss))
	ss.interact_area.player_exited.connect(pop.bind(ss))

func connect_to_mine_anchor(ma: MineAnchor) -> void:
	ma.interact_area.player_entered.connect(show_mine_anchor_prompt.bind(ma))
	ma.interact_area.player_exited.connect(pop.bind(ma))
	
func show_trade_prompt(space_station: SpaceStation) -> void:
	#add to stack
	push(space_station, %TradePrompt)
	
	%TradeCostLabel.text = str(space_station.cost_per_unit)
	%TradeMineralTextureRect.texture = space_station.cost_mineral.mineral_icon
	hide_all_except(%TradePrompt)

func show_mine_anchor_prompt(mine_anchor: MineAnchor) -> void:
	#add to stack
	push(mine_anchor, %MineAnchorPrompt)
	hide_all_except(%MineAnchorPrompt)

func hide_all_except(child: Control) -> void:
	for c in get_children():
		c.hide()
	
	child.show()

func push(source: Object, element: Control) -> void:
	stack.append({"source": source, "element": element})

func pop(source: Object) -> void:
	for item in stack:
		if item["source"] == source:
			item["element"].hide()
			stack.erase(item)
			break
	
	
	if not stack.is_empty(): 
		var back = stack.back()
		back["source"].show()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not stack.is_empty():
			prompt_interacted.emit(stack.back()["source"])
		
