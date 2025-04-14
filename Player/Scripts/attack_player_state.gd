class_name AttackPlayerState
extends State

@onready var hitbox = $"../../AttackDirection/HitBox"  # Это Area2D

const ATTACK_ANIMATIONS = ["Attack1", "Attack2", "Attack3"]
var combo_index: int = 0
var combo_requested: bool = false  # Флаг для запроса следующего удара комбо
var sound_played: bool = false      # Флаг, чтобы звук проигрывался только один раз за запуск анимации

func enter() -> void:
	entity.velocity.x = 0
	combo_index = 0
	combo_requested = false
	sound_played = false
	_play_attack_animation()  # Запускаем первую атаку
	
	# Подключаем сигнал хитбокса, если он ещё не подключён
	if not hitbox.is_connected("body_entered", Callable(self, "_on_HitBox_body_entered")):
		hitbox.connect("body_entered", Callable(self, "_on_HitBox_body_entered"))
	
	entity.is_blocking = false
	entity.is_sliding = false

func exit() -> void:
	call_deferred("_deferred_disconnect")

func _deferred_disconnect() -> void:
	if hitbox and hitbox.is_connected("body_entered", Callable(self, "_on_HitBox_body_entered")):
		hitbox.disconnect("body_entered", Callable(self, "_on_HitBox_body_entered"))

func update(_delta: float) -> void:
	# Регистрируем запрос комбо, но не проигрываем звук здесь
	if Input.is_action_just_pressed("Attack"):
		combo_requested = true

	# Если анимация атаки закончилась
	if not entity.animplayer.is_playing():
		if combo_requested and combo_index < ATTACK_ANIMATIONS.size() - 1:
			combo_index += 1
			combo_requested = false
			sound_played = false  # Сбрасываем флаг, чтобы при следующей атаке звук проигрался заново
			_play_attack_animation()
		else:
			# Если нет запроса комбо, переходим в состояние бега или ожидания
			var input_vector = entity.get_input_vector()
			if abs(input_vector.x) > 0:
				transition.emit("RunningPlayerState")
			else:
				transition.emit("IdlePlayerState")
	
	# Переходы в другие состояния (при прыжке, блоке, ультимативной атаке или падении)
	if Input.is_action_just_pressed("Jump") and entity.is_on_floor():
		transition.emit("JumpPlayerState")
	
	if Input.is_action_just_pressed("Block") and entity.is_on_floor():
		transition.emit("BlockPlayerState")
	
	if Input.is_action_just_pressed("Ultimative") and entity.is_on_floor():
		transition.emit("UltimativePlayerState")
	
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("player_attack", entity.damage, entity.global_position)

func _play_attack_animation() -> void:
	# Выбираем название анимации по текущему индексу комбо
	var anim_name = ATTACK_ANIMATIONS[combo_index]
	entity.animplayer.play(anim_name)
	# Проигрываем звук только если ещё не проигран для этой конкретной анимации
	if not sound_played:
		$"../../SFX/AttackAudio2D".play_attack(combo_index)
		sound_played = true
