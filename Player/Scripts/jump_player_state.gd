class_name JumpPlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Jump", 0.0)
	$"../../SFX/JumpAudio2D".play()
	entity.apply_jump()
	entity.is_blocking = false
	entity.is_sliding = false

func update(delta: float) -> void:
	var iv = entity.get_input_vector()
	entity.apply_movement(iv, delta)
	entity.change_direction(iv.x)
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# 1) Переходим в Fall только если мы действительно в воздухе и уже прыгаем вниз
	if entity.velocity.y > 10.0 and not entity.is_on_floor():
		# сразу же показываем Fall
		entity.animplayer.stop()
		entity.animplayer.play("Fall", 0.0)
		transition.emit("FallPlayerState")
		return

	# 2) Проверяем посадку на землю
	if entity.is_on_floor():
		transition.emit("RunningPlayerState")
