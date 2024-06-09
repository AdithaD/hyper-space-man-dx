extends Node
class_name BehaviourTree
## The root of a tree of behaviour tree nodes. Behaviour trees allow for the tree structure 
## of the children to dictate how the behaviour of the actor is determined. 
## Every physics frame a leaf node is found based on the logic of the child nodes and is evaluated.
@export var enabled = true
## The entity who's behaviour this behaviour tree is controlling
@onready var actor = get_parent()

## A dictionary that can hold scratch data for executing the blackboard.
var blackboard : BehaviourTreeBlackboard



func _init():
	blackboard = BehaviourTreeBlackboard.new()

func _ready() -> void:
	await actor.ready
	get_child(0).init_behaviour(actor, blackboard)

func _physics_process(delta: float) -> void:
	blackboard.set_value("delta", delta)
	
	if enabled:
		# updates it's first child.
		get_child(0).update(actor, blackboard)
	
	#var active_node = get_child(0).get_active_node()
	#if active_node:
		#print(active_node.get_path())

