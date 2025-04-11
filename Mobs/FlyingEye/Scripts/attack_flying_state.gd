#attack_Flying_state.gd
class_name AttackFlyingState
extends State

var has_attacked: bool = false  # Флаг, чтобы атака происходила один раз за анимацию

func enter() -> void:
	entity.velocity.x = 0
	has_attacked = false  # Сбрасываем флаг атаки
	entity.animplayer.play("Attack1")  # Запускаем анимацию атаки

func exit() -> void:
	has_attacked = false  # Сбрасываем флаг при выходе
	#entity.animplayer.stop()  # Останавливаем анимацию при выходе. Эта строка выдает ошибку

func update(_delta: float) -> void:
	# Проверяем завершение анимации атаки
	if not entity.animplayer.is_playing():  
		# Анимация закончилась
		if not _is_player_in_attack_range():  
			transition.emit("ChaseFlyingState")  # Если игрок покинул зону атаки, возвращаемся в погоню
		else:
			# Если игрок все еще в зоне атаки, продолжим атаковать
			has_attacked = false  # Сбрасываем флаг для возможности повторной атаки
			entity.animplayer.play("Attack1")  # Перезапускаем анимацию, чтобы она не зависала

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _is_player_in_attack_range() -> bool:
	# Проверяем, есть ли игрок в области атаки
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			return true
	return false

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)
