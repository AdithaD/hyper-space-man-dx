extends Label

@export var behaviour_tree: BehaviourTree

func _physics_process(_delta: float) -> void:
	var first_child : BehaviourTreeNode = behaviour_tree.get_child(0)
	var active_node := first_child.get_active_node()
	
	if active_node:
		text = active_node.name
