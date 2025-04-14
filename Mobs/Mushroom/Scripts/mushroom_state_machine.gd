class_name MushroomStateMachine
extends Node

@onready var healthbar: TextureProgressBar = $"../MobHealth/HealthBar"
var max_health: int = 100
var health: int = max_health

@export var current_state: State
var states: Dictionary = {}

var player_damage
var player_global_position

func _ready() -> void:
	await owner.ready
	healthbar.max_value = max_health
	healthbar.value = health
	
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
	player_damage = damage
	player_global_position = global_position

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	await get_tree().create_timer(0.05).timeout
	owner.last_player_position = player_global_position
	health -= player_damage
	healthbar.value = health
	
	if health > 0:
		on_child_transition("DamageMushroomState")
	else:
		health = 0
		on_child_transition("DeathMushroomState")

func _on_hit_box_area_entered(_area: Area2D) -> void:
	pass  
