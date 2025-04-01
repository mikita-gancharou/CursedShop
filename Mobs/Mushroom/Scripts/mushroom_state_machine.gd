class_name MushroomStateMachine
extends Node

@export var current_state: State
var states: Dictionary = {}
var health: int = 100  # Пример: здоровье моба

func _ready() -> void:
	await owner.ready

	# Регистрируем дочерние состояния
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node: " + child.name)
	
	if current_state:
		current_state.enter()

	else:
		push_warning("No initial state set in MushroomStateMachine")
	
	# Подписываемся на сигнал атаки игрока
	Signals.connect("player_attack", Callable(self, "_on_player_attack"))

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

func _on_player_attack(damage, global_position) -> void:
	# Можно добавить проверку расстояния между мобом и атакующим (global_position),
	# если это требуется для логики столкновения.
	owner.last_player_position = global_position
	owner.health -= damage
	print("Mob health:", owner.health)
	
	if owner.health > 0:
		on_child_transition("DamageState")
	else:
		owner.health = 0
		on_child_transition("DeathState")
