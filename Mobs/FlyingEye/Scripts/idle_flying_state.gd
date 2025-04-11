class_name IdleFlyingState
extends State

func enter() -> void:
	entity.animplayer.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Получаем узел DetectionArea
	var detection_area = entity.get_node("DetectionArea")
	if detection_area:
		# Получаем список тел, пересекающих область
		var bodies = detection_area.get_overlapping_bodies()
		for body in bodies:
			# Если обнаружен игрок, инициируем переход в состояние погони
			if body is Player:
				transition.emit("ChaseFlyingState")
				return  # Завершаем, чтобы не вызывать переход несколько раз
	else:
		push_warning("DetectionArea didn't found")
		
func physics_update(_delta: float) -> void:
	pass
