# state_machine.gd

class_name StateMachine
extends Node

@export var current_state: State
var states: Dictionary = {}

var owner_character: CharacterBody2D  # Ссылка на объект, которому принадлежат состояния

# Метод для инициализации с передаваемым объектом
func setup(character: CharacterBody2D) -> void:
	owner_character = character
	var initial_state: State = null

	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
			if initial_state == null:  # Устанавливаем начальное состояние, если оно еще не выбрано
				initial_state = child
		else:
			push_warning("State machine contains incompatible child node")

	if initial_state != null:
		current_state = initial_state
		current_state.enter(owner_character)  # Теперь текущий state точно существует
	else:
		push_warning("No valid state found in StateMachine")

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter(owner_character)  # Передаем тот же объект в новое состояние
			current_state = new_state
	else:
		push_warning("State does not exist")
