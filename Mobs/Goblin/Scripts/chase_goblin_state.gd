class_name ChaseGoblinState
extends State

func enter() -> void:
	owner.is_blocking = false
	entity.animplayer.play("Run")
	# Подключаем сигнал на вход в зону атаки
	entity.attack_area.body_entered.connect(_on_attack_area_entered)
	
	# Немедленно проверяем, находится ли игрок уже в зоне атаки
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			transition.emit("AttackGoblinState")
			return

func exit() -> void:
	entity.attack_area.body_entered.disconnect(_on_attack_area_entered)

func update(delta: float) -> void:
	# Если игрок мёртв, переходим в Idle
	if entity.player.is_dead:
		transition.emit("IdleGoblinState")
		return
	
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	var player = entity.player
	var direction = (player.global_position - entity.global_position).normalized()
	entity.change_direction(direction.x)
	entity.apply_movement(Vector2(direction.x, 0), delta)
	
	# Дополнительная проверка: если игрок входит в зону атаки, переключаемся в состояние атаки
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			transition.emit("AttackGoblinState")
			return

func physics_update(_delta: float) -> void:
	pass

func _on_attack_area_entered(body: Node2D) -> void:
	# Если игрок (и он живой) входит в зону атаки, переключаемся в Attack
	if body.is_in_group("Player") and not body.is_dead:
		transition.emit("AttackGoblinState")
