class_name AttackFlyingState
extends State

var has_attacked: bool = false
var attack_index: int = 0  # 0 = Attack1, 1 = Attack2, 2 = Attack3

func enter() -> void:
	entity.velocity.x = 0
	has_attacked = false
	# При входе всегда проигрываем ту анимацию, на которой остановились
	_play_next_attack()

func exit() -> void:
	has_attacked = false
	# attack_index НЕ сбрасываем

func update(_delta: float) -> void:
	if entity.player.is_dead:
		transition.emit("IdleFlyingState")
		return

	# Если анимация атаки закончилась
	if not entity.animplayer.is_playing():
		# Сбрасываем флаг удара и сразу инкрементируем индекс
		has_attacked = false
		attack_index = (attack_index + 1) % 3

		# В зависимости от того, в зоне ли игрок, либо атакуем дальше, либо уходим в Chase
		if _is_player_in_attack_range():
			_play_next_attack()
		else:
			transition.emit("ChaseFlyingState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _play_next_attack() -> void:
	match attack_index:
		0:
			entity.animplayer.play("Attack1")
		1:
			entity.animplayer.play("Attack2")
		2:
			entity.animplayer.play("Attack3")

func _is_player_in_attack_range() -> bool:
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _on_hit_box_area_entered(_area: Area2D) -> void:
	if not has_attacked:
		Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)
		has_attacked = true
