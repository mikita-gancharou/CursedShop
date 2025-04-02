# PlayerStateMachine
class_name PlayerStateMachine
extends Node

signal health_changed(new_health)

@export var current_state: State



var states: Dictionary = {}


func _ready() -> void:
	await owner.ready

	# Регистрируем все дочерние узлы, которые являются состояниями
	for child in get_children():
		if child is State:
			states[child.name] = child
			#print("Registered state:", child.name)
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node: " + child.name)

	# Подписка на глобальный сигнал атаки
	Signals.connect("enemy_attack", Callable (self, "_on_damage_received"))

	# После регистрации вызываем начальное состояние
	if current_state:
		current_state.enter()
	else:
		push_warning("No initial state set in PlayerStateMachine")

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	#print(current_state)
	if current_state:
		current_state.physics_update(delta)

# Обработчик перехода между состояниями
func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		# Чтобы не переходить в одно и то же состояние
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
	else:
		push_warning("State does not exist: " + str(new_state_name))


func _on_damage_received(enemy_damage, enemy_global_position):
	owner.last_enemy_position = enemy_global_position
	
	if owner.is_sliding == false and owner.is_blocking == false:
		owner.health -= enemy_damage
		owner.healthbar.value = owner.health
		emit_signal("health_changed", owner.health)
	
	if owner.health > 0:
		on_child_transition("DamagePlayerState")
	else:
		owner.health = 0
		on_child_transition("DeathPlayerState")

func add_health(healing) -> void:
		owner.health += healing
		if owner.health > owner.max_health:
			owner.health = owner.max_health
			owner.healthbar.value = owner.health
			emit_signal("health_changed", owner.health)
