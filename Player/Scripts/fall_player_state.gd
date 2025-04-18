class_name FallPlayerState
extends State

var landed: bool = false
var ready_to_land: bool = false

func enter() -> void:
	landed = false
	ready_to_land = false
	# Сброс любых предыдущих анимаций и запуск Fall сразу
	entity.animplayer.stop()
	entity.animplayer.play("Fall")
	# Отложенный флаг, чтобы первый кадр точно отработал
	call_deferred("_enable_landing")

func _enable_landing() -> void:
	# Этот флаг позволит начать проверять is_on_floor() только после enter()
	ready_to_land = true

func update(delta: float) -> void:
	# Физика движения
	var input_vector = entity.get_input_vector()
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# Начинаем проверять попадание на пол только после deferred
	if ready_to_land and entity.is_on_floor():
		# Если игрок сразу путает действия, даём приоритет прыжку
		if Input.is_action_just_pressed("Jump"):
			transition.emit("JumpPlayerState")
			return
		elif Input.is_action_just_pressed("Slide"):
			transition.emit("SlidePlayerState")
			return
		elif Input.is_action_just_pressed("Attack"):
			transition.emit("AttackPlayerState")
			return
		elif Input.is_action_pressed("Block"):
			transition.emit("BlockPlayerState")
			return
		elif Input.is_action_just_pressed("Ultimative"):
			transition.emit("UltimativePlayerState")
			return

		# Если мы впервые приземлились — проигрываем «Land»
		if not landed:
			landed = true
			entity.animplayer.play("Land")
		# После окончания анимации приземления — в бег
		elif not entity.animplayer.is_playing():
			transition.emit("RunningPlayerState")

func physics_update(_delta: float) -> void:
	pass
