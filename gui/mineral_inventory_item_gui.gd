extends HBoxContainer

@export var mineral : Mineral

func set_mineral(value: Mineral, amount = 0):
	mineral = value
	update(amount)

func update(amount: int = 0):
	if mineral:
		$TextureRect.texture = mineral.mineral_icon
		$MineralNameLabel.text = mineral.mineral_name
		
		$MineralAmountLabel.text = str(amount)
		show()
	else:
		hide()
