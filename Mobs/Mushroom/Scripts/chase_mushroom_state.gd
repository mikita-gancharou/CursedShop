class_name ChaseMushroomState
extends State

var idle_timer_running: bool = false

func enter() -> void:
	owner.is_blocking = false
	entity.animplayer.play("Run")

	# Групповой алерт (однократно)
	if entity.mob_group != 0 and not entity.has_been_alerted:
		entity.has_been_alerted = true
		Signals.emit_signal("group_alert", entity.mob_group, entity.player.global_position)

	# Подключение сигналов, только если ещё не подключены
	if not entity.attack_area.body_entered.is_connected(_on_attack_area_entered):
		entity.attack_area.body_entered.connect(_on_attack_area_entered)

	var det = entity.get_node("DetectionArea") as Area2D

	if not det.body_entered.is_connected(_on_detection_area_body_entered):
		det.body_entered.connect(_on_detection_area_body_entered)

	if not det.body_exited.is_connected(_on_detection_area_body_exited):
		det.body_exited.connect(_on_detection_area_body_exited)

func exit() -> void:
	# Отключение сигналов
	if entity.attack_area.body_entered.is_connected(_on_attack_area_entered):
		entity.attack_area.body_entered.disconnect(_on_attack_area_entered)

	var det = entity.get_node("DetectionArea") as Area2D

	if det.body_entered.is_connected(_on_detection_area_body_entered):
		det.body_entered.disconnect(_on_detection_area_body_entered)

	if det.body_exited.is_connected(_on_detection_area_body_exited):
		det.body_exited.disconnect(_on_detection_area_body_exited)

func update(delta: float) -> void:
	# Если игрок мёртв — в Idle
	if entity.player.is_dead:
		transition.emit("IdleMushroomState")
		return

	# Физика
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# Преследование
	var dir = (entity.player.global_position - entity.global_position).normalized()
	entity.change_direction(dir.x)
	entity.apply_movement(Vector2(dir.x, 0), delta)

func physics_update(_delta: float) -> void:
	pass

func _on_attack_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not body.is_dead:
		transition.emit("AttackMushroomState")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_dead:
		idle_timer_running = false

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player and not body.is_dead and not idle_timer_running:
		idle_timer_running = true
		_start_idle_timer()

func _start_idle_timer() -> void:
	await get_tree().create_timer(5.0).timeout
	idle_timer_running = false
	if not _is_player_in_detection_area() and not entity.is_dead:
		transition.emit("IdleMushroomState")

func _is_player_in_detection_area() -> bool:
	var det = entity.get_node("DetectionArea") as Area2D
	for b in det.get_overlapping_bodies():
		if b is Player and not b.is_dead:
			return true
	return false
