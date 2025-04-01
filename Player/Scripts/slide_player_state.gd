class_name SlidePlayerState
extends State

var slide_velocity := Vector2.ZERO

func enter() -> void:
	entity.animplayer.play("Slide")
	
	# Определяем направление по свойству flip_h спрайта
	var slide_direction = -1 if entity.sprite.flip_h else 1
	var slide_speed = 350.0  # Настраивайте под баланс игры
	slide_velocity = Vector2(slide_speed * slide_direction, 0)

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Применяем сохранённую скорость скольжения
	entity.velocity.x = slide_velocity.x
	
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Симуляция трения: постепенно замедляем персонажа
	slide_velocity.x = move_toward(slide_velocity.x, 0, 500 * delta)
	
	# Если скорость скольжения становится очень низкой — переходим в idle
	if abs(slide_velocity.x) < 10.0:
		transition.emit("IdlePlayerState")
	
	# Переход в прыжок, если нажата кнопка прыжка и персонаж на земле
	if Input.is_action_just_pressed("Jump") and entity.is_on_floor():
		transition.emit("JumpPlayerState")
	
	# Если падаем, переключаемся в состояние падения
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")
	
	if Input.is_action_just_pressed("Attack") and owner.is_on_floor():
		transition.emit("AttackPlayerState")

func physics_update(delta: float) -> void:
	pass
