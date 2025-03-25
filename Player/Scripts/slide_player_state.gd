class_name SlidePlayerState
extends State

var slide_duration: float = 0.5  # Минимальное время в слайде
var slide_timer: float = 0.0
var slide_speed: float = 200.0  # Скорость слайда
var slide_jump_multiplier: float = 0.09  # 0.09 = casual jump

func enter(character: CharacterBody2D) -> void:
	owner_character = character

	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.play("Slide")

	owner_character.is_sliding = true
	owner_character.stand_collision.disabled = true
	owner_character.slide_collision.disabled = false

	slide_timer = slide_duration  # Запуск таймера

	# Устанавливаем фиксированную скорость слайда
	var direction = -1 if owner_character.sprite.flip_h else 1
	owner_character.velocity.x = direction * slide_speed

func exit() -> void:
	owner_character.stand_collision.disabled = false
	owner_character.slide_collision.disabled = true
	owner_character.is_sliding = false

func update(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		# Применяем ограниченную силу прыжка
		owner_character.velocity.y = -owner_character.jump_velocity * slide_jump_multiplier
		transition.emit("JumpPlayerState")
		return

	# Всегда применяем гравитацию, если персонаж не на земле
	if not owner_character.is_on_floor():
		owner_character.apply_gravity(delta)
		if owner_character.velocity.y > 10:
			transition.emit("FallPlayerState")
			return

	# Уменьшаем таймер слайда, если он ещё не истёк
	if slide_timer > 0:
		slide_timer -= delta

	# Если персонаж на земле и время слайда истекло — переключаемся
	if owner_character.is_on_floor() and slide_timer <= 0:
		transition.emit("RunningPlayerState" if abs(owner_character.velocity.x) > 0 else "IdlePlayerState")

func physics_update(delta: float) -> void:
	owner_character.apply_velocity(delta)
