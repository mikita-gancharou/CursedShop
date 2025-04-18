class_name IdleGoblinState
extends State

func enter() -> void:
	entity.animplayer.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Если игрок мёртв, остаёмся в Idle
	if entity.player.is_dead:
		return

	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Получаем DetectionArea (обязательно добавьте его в узлы скелета)
	var detection_area = entity.get_node("DetectionArea")
	if detection_area:
		# Проходим по телам, пересекающим область обнаружения
		for body in detection_area.get_overlapping_bodies():
			# Если обнаружен живой игрок, инициируем переход в погоню
			if body is Player and not body.is_dead:

				transition.emit("ChaseGoblinState")
				return
	else:
		push_warning("DetectionArea not found in Goblin")
		
func physics_update(_delta: float) -> void:
	pass
