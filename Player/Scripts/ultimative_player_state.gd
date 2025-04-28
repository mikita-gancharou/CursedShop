class_name UltimativePlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Ultimative")
	$"../../SFX/UltimativeAudio2D".play()
	
	entity.velocity.x = 0

	entity.is_blocking = false
	entity.is_sliding = false

	# Подписываемся на окончание анимации
	entity.animplayer.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	# Отписываемся, чтобы не было лишних вызовов
	entity.animplayer.animation_finished.disconnect(_on_animation_finished)

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()

	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	# Переход в другие состояния только если анимация завершилась
	if entity.animplayer.is_playing():
		return

	# States transition:
	if input_vector.x == 0:
		transition.emit("IdlePlayerState")

	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")

	if input_vector.x != 0:
		transition.emit("RunningPlayerState")

	if Input.is_action_just_pressed("Jump") and owner.is_on_floor():
		transition.emit("JumpPlayerState")

	if Input.is_action_just_pressed("Slide") and owner.is_on_floor():
		transition.emit("SlidePlayerState")

	if Input.is_action_just_pressed("Attack") and owner.is_on_floor():
		transition.emit("AttackPlayerState")

	if Input.is_action_pressed("Block") and owner.is_on_floor():
		transition.emit("BlockPlayerState")

func physics_update(_delta: float) -> void:
	pass

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Ultimative":
		transition.emit("IdlePlayerState")


func _on_ultimate_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("player_attack", Global.damage, entity.global_position)
