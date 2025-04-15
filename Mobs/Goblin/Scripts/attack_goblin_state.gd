class_name AttackGoblinState
extends State

@export var bomb_scene: PackedScene

var has_attacked: bool = false  # Флаг, чтобы атака происходила один раз за анимацию
var combo: bool = false         # false = Attack1, true = Attack2 (обычные атаки)
var bomb_thrown: bool = false   # Флаг, гарантирующий, что бомба будет брошена только один раз

func enter() -> void:
	entity.velocity.x = 0
	has_attacked = false 
	combo = true
	entity.animplayer.play("Attack1")

func exit() -> void:
	combo = false
	has_attacked = false

func update(_delta: float) -> void:
	# Если игрок мёртв, переключаемся в Idle
	if entity.player.is_dead:
		transition.emit("IdleGoblinState")
		return
	
	# Если игрок находится в DetectionArea и бомба ещё не брошена,
	# выполняем бросок бомбы с анимацией ThrowBomb.
	var detection_area = entity.get_node("DetectionArea")
	if detection_area:
		for body in detection_area.get_overlapping_bodies():
			if body.is_in_group("Player") and not body.is_dead:
				if not bomb_thrown:
					entity.animplayer.play("ThrowBomb")
					#_throw_bomb()
					bomb_thrown = true
					return  # Прерываем дальнейшую обработку update
	
	# Если анимация атаки завершилась, обрабатываем обычное чередование Attack1 / Attack2
	if not entity.animplayer.is_playing():
		# Если игрок уже вышел из зоны атаки – переключаемся в погоню
		if not _is_player_in_attack_range():
			if _is_player_in_attack_range2() and combo:
				entity.animplayer.play("Attack2")
			else:
				transition.emit("ChaseGoblinState")
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
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _is_player_in_attack_range2() -> bool:
	for body in entity.attack_area2.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)

func _throw_bomb() -> void:
	# Этот метод вызывается в анимации ThrowBomb через Call Method Track
	if bomb_scene:
		var bomb = bomb_scene.instantiate()
		var throw_offset = Vector2(-10 if entity.sprite.flip_h else 10, -10)
		bomb.global_position = entity.global_position + throw_offset
		var direction = (entity.player.global_position - entity.global_position).normalized()
		bomb.linear_velocity = direction * 200.0  # настройте силу при необходимости
		entity.get_tree().current_scene.add_child(bomb)
