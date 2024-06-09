extends Label

@export var behaviour_tree :BehaviourTree

func _physics_process(delta: float) -> void:
	var active_node = behaviour_tree.get_child(0).get_active_node()
	
	if active_node:
		text = active_node.name
