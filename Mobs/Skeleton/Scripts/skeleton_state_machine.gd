class_name SkeletonStateMachine
extends Node

@export var current_state: State
var states: Dictionary = {}
var health: int = 100  # Пример: здоровье моба

var player_damage
var player_global_position

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
		push_warning("No initial state set in SkeletonStateMachine")
	
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
	player_damage = damage
	player_global_position = global_position

func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("Hurtbox area entered")
	await get_tree().create_timer(0.05).timeout
	owner.last_player_position = player_global_position
	owner.health -= player_damage
	print("Mob health:", owner.health)
	
	if owner.health > 0:
		on_child_transition("DamageSkeletonState")
	else:
		owner.health = 0
		on_child_transition("DeathSkeletonState")


func _on_hit_box_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
