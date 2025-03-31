class_name MushroomStateMachine
extends Node

@export var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	await owner.ready

	for child in get_children():
		#print("Checking child:", child.name, "Type:", child.get_class())
		if child is State:
			states[child.name] = child
			print("Registered state:", child.name)
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node: " + child.name)
	
	if current_state:
		#print("Initial state:", current_state.name)
		current_state.enter()
	else:
		push_warning("No initial state set in PlayerStateMachine")

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
	else:
		push_warning("State does not exist: " + str(new_state_name))
