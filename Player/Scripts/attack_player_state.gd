class_name AttackPlayerState
extends State

@onready var hitbox = $"../../AttackDirection/HitBox"  # Это Area2D

const ATTACK_ANIMATIONS = ["Attack1", "Attack2", "Attack3"]
var combo_index: int = 0
var combo_requested: bool = false  # Флаг для запроса комбо

func enter() -> void:
	entity.velocity.x = 0
	combo_index = 0
	combo_requested = false
	_play_attack_animation()
	
	# Подключаем сигнал хитбокса, если он ещё не подключён
	if not hitbox.is_connected("body_entered", Callable(self, "_on_HitBox_body_entered")):
		hitbox.connect("body_entered", Callable(self, "_on_HitBox_body_entered"))
	
	entity.is_blocking = false
	entity.is_sliding = false
	
	$"../../SFX/AttackAudio2D".play_attack(combo_index)

func exit() -> void:
	call_deferred("_deferred_disconnect")

func _deferred_disconnect() -> void:
	if hitbox and hitbox.is_connected("body_entered", Callable(self, "_on_HitBox_body_entered")):
		hitbox.disconnect("body_entered", Callable(self, "_on_HitBox_body_entered"))

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		combo_requested = true
		$"../../SFX/AttackAudio2D".play_attack(combo_index)

	if not entity.animplayer.is_playing():
		if combo_requested and combo_index < ATTACK_ANIMATIONS.size() - 1:
			combo_index += 1
			combo_requested = false
			_play_attack_animation()
		else:
			var input_vector = entity.get_input_vector()
			if abs(input_vector.x) > 0:
				transition.emit("RunningPlayerState")
			else:
				transition.emit("IdlePlayerState")
	
	# Переходы в другие состояния
	if Input.is_action_just_pressed("Jump") and entity.is_on_floor():
		transition.emit("JumpPlayerState")
	
	if Input.is_action_just_pressed("Block") and owner.is_on_floor():
		transition.emit("BlockPlayerState")
	
	if Input.is_action_just_pressed("Ultimative") and owner.is_on_floor():
		transition.emit("UltimativePlayerState")

	
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("player_attack", entity.damage, entity.global_position)

func _play_attack_animation() -> void:
	var anim_name = ATTACK_ANIMATIONS[combo_index]
	entity.animplayer.play(anim_name)
