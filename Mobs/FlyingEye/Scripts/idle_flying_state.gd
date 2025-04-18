class_name IdleFlyingState
extends State

func enter() -> void:
	entity.animplayer.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if entity.player.is_dead:
		return

	var detection_area = entity.get_node("DetectionArea")
	if detection_area:
		# Проходим по телам, пересекающим область обнаружения
		for body in detection_area.get_overlapping_bodies():
			# Если обнаружен живой игрок, инициируем переход в погоню
			if body is Player and not body.is_dead:
				transition.emit("ChaseFlyingState")
				return
	else:
		push_warning("DetectionArea not found in Flying")

func physics_update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
