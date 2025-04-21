class_name FallPlayerState
extends State

var landed: bool = false
var fall_initialized: bool = false

func enter() -> void:
	landed = false
	fall_initialized = false
	# Принудительно сбрасываем и откладываем запуск Fall
	entity.animplayer.stop()
	call_deferred("_play_fall")

func _play_fall() -> void:
	entity.animplayer.play("Fall", 0.0)
	fall_initialized = true

func update(delta: float) -> void:
	# Если по какой-то причине Fall не успел запуститься, форсируем ещё раз
	if not fall_initialized:
		entity.animplayer.play("Fall", 0.0)
		fall_initialized = true

	# Физика движения
	var iv = entity.get_input_vector()
	entity.apply_movement(iv, delta)
	entity.change_direction(iv.x)
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# Как только коснулись пола, даём приоритет действиям
	if entity.is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			transition.emit("JumpPlayerState")
			return
		if Input.is_action_just_pressed("Slide"):
			transition.emit("SlidePlayerState")
			return
		if Input.is_action_just_pressed("Attack"):
			transition.emit("AttackPlayerState")
			return
		if Input.is_action_pressed("Block"):
			transition.emit("BlockPlayerState")
			return
		if Input.is_action_just_pressed("Ultimative"):
			transition.emit("UltimativePlayerState")
			return

		# Если приземлились впервые — проигрываем Land
		if not landed:
			landed = true
			entity.animplayer.play("Land", 0.0)
		# После окончания Land — в бег
		elif not entity.animplayer.is_playing():
			transition.emit("RunningPlayerState")

func physics_update(_delta: float) -> void:
	pass
