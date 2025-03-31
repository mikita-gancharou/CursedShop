class_name IdleMushroomState
extends State

func enter() -> void:
	entity.sprite.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Получаем узел DetectionArea2D
	var detection_area = entity.get_node("DetectionArea2D")
	if detection_area:
		# Получаем список тел, пересекающих область
		var bodies = detection_area.get_overlapping_bodies()
		for body in bodies:
			# Если обнаружен игрок, инициируем переход в состояние погони
			if body is Player:
				transition.emit("ChaseMushroomState")
				return  # Завершаем, чтобы не вызывать переход несколько раз
	else:
		push_warning("DetectionArea2D не найден у моба")
		
func physics_update(delta: float) -> void:
	pass
