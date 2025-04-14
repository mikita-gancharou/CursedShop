class_name AttackSkeletonState
extends State

var has_attacked: bool = false  # Флаг, чтобы атака происходила один раз за анимацию
var combo: bool = false

func enter() -> void:
	entity.velocity.x = 0
	
	
	has_attacked = false 
	combo = true
	entity.animplayer.play("Attack1")  # Запускаем анимацию атаки

func exit() -> void:
	combo = false
	has_attacked = false

func update(_delta: float) -> void:
	# Если игрок мёртв, переключаемся в Idle
	if entity.player.is_dead:
		transition.emit("IdleSkeletonState")
		return
	
	# Проверяем завершение анимации атаки
	if not entity.animplayer.is_playing():
		# Если игрок (живой) уже покинул зону атаки – возвращаемся к погоне
		if not _is_player_in_attack_range():
			transition.emit("ChaseSkeletonState")
		else:
			has_attacked = false
			if combo:
				entity.animplayer.play("Attack2")
				combo = false
			else: 
				entity.animplayer.play("Attack1")
				combo = true
				
func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _is_player_in_attack_range() -> bool:
	# Перебираем тела в зоне атаки и ищем живого игрока
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)
