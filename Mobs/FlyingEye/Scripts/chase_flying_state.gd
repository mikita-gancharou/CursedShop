class_name ChaseFlyingState
extends State

var idle_timer_running: bool = false

func enter() -> void:
	owner.is_blocking = false
	entity.animplayer.play("Idle")
	# Подключаемся к сигналам атаки и зоны обнаружения
	entity.attack_area.body_entered.connect(_on_attack_area_entered)
	var det_area: Area2D = entity.get_node("DetectionArea")
	det_area.body_exited.connect(_on_detection_area_body_exited)
	det_area.body_entered.connect(_on_detection_area_body_entered)

func exit() -> void:
	entity.attack_area.body_entered.disconnect(_on_attack_area_entered)
	var det_area: Area2D = entity.get_node("DetectionArea")
	det_area.body_exited.disconnect(_on_detection_area_body_exited)
	det_area.body_entered.disconnect(_on_detection_area_body_entered)

func update(delta: float) -> void:
	# Если игрок мёртв, переходим в Idle
	if entity.player.is_dead:
		transition.emit("IdleFlyingState")
		return

	# Физика движения
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# Преследуем игрока
	var dir = (entity.player.global_position - entity.global_position).normalized()
	entity.change_direction(dir.x)
	entity.apply_movement(Vector2(dir.x, 0), delta)

func physics_update(_delta: float) -> void:
	pass

func _on_attack_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not body.is_dead:
		transition.emit("AttackFlyingState")

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Если игрок вернулся, сбрасываем таймер
	if body is Player and not body.is_dead:
		idle_timer_running = false

func _on_detection_area_body_exited(body: Node2D) -> void:
	# При выходе запускаем таймер, если он ещё не запущен
	if body is Player and not body.is_dead and not idle_timer_running:
		idle_timer_running = true
		_start_idle_timer()

func _start_idle_timer() -> void:
	# Ждём 5 секунд перед переходом в Idle
	await get_tree().create_timer(5.0).timeout
	idle_timer_running = false
	# Если моб жив и игрок не вернулся — переходим в Idle
	if not _is_player_in_detection_area() and not entity.is_dead:
		transition.emit("IdleFlyingState")

func _is_player_in_detection_area() -> bool:
	var det_area: Area2D = entity.get_node("DetectionArea")
	for b in det_area.get_overlapping_bodies():
		if b is Player and not b.is_dead:
			return true
	return false
