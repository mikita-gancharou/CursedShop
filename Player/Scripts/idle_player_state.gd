class_name IdleState
extends State

func enter() -> void:
	# Используем entity вместо player, так как это универсально для всех типов сущностей
	entity.sprite.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Получаем ввод с универсальной сущности
	var input_vector = entity.get_input_vector()
	
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Переход в состояние "Running" или другие состояния
	if input_vector.x != 0:
		transition.emit("RunningPlayerState")

func physics_update(delta: float) -> void:
	pass
