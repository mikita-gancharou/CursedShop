# PlayerStateMachine
class_name PlayerStateMachine
extends Node

@export var current_state: State



var states: Dictionary = {}
const MIN_DAMAGE : int = 5

func _ready() -> void:
	randomize()
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
	Signals.connect("lava_attack", Callable (self, "_on_lava_damage_received"))
	Signals.connect("gold_changed", Callable (self, "_on_gold_changed"))
	Signals.connect("chest_opened", Callable (self, "_on_chest_opened"))
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
			#print(current_state)
	else:
		push_warning("State does not exist: " + str(new_state_name))


func _on_damage_received(enemy_damage, enemy_global_position):
	owner.last_enemy_position = enemy_global_position
	
	if owner.is_sliding == false and owner.is_blocking == false:
		var final_damage : int = max(enemy_damage - Global.armor, MIN_DAMAGE)
		owner.health -= final_damage
		change_health()
	if owner.health > 0:
		on_child_transition("DamagePlayerState")
	else:
		owner.health = 0
		on_child_transition("DeathPlayerState")

func _on_lava_damage_received(enemy_damage, _enemy_global_position):
	var final_damage : int = max(enemy_damage - Global.armor, MIN_DAMAGE)
	owner.health -= final_damage
	change_health()
	
	if owner.health > 0:
		$"../SFX/DamageAudio2D".play_damage()
	else:
		owner.health = 0
		on_child_transition("DeathPlayerState")


func add_health(healing) -> void:
		owner.health += healing
		change_health()

func _on_gold_changed() -> void:
	owner.gold_label.text = str(Global.gold)

func attack_change() -> void:
	owner.attack_label.text = str(Global.damage)

func armor_change() -> void:
	owner.armor_label.text = str(Global.armor)

func _on_chest_opened(choice) -> void:
	match choice:
		0:
			owner.max_health += 10
			owner.health += 10
			change_health()
		1:
			Global.damage += 5
			attack_change()
		2:
			Global.armor += 1
			armor_change()

func change_health():
	if owner.health > owner.max_health:
		owner.health = owner.max_health
	if owner.health < 0:
		owner.health = 0
	owner.healthbar.value = owner.health
	owner.healthbar.max_value = owner.max_health
	owner.healthbar_text.text = str(owner.health) + "/" + str(owner.max_health)
