class_name ChaseMushroomState
extends State

func enter() -> void:
	entity.animplayer.play("Run")
	entity.attack_area.body_entered.connect(_on_attack_area_entered)

func exit() -> void:
	entity.attack_area.body_entered.disconnect(_on_attack_area_entered)

func update(delta: float) -> void:
	# Если игрок мёртв, остаёмся в Idle
	if entity.player.is_dead:
		transition.emit("IdleMushroomState")
		return
	
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Используем ссылку на игрока из скелета
	var player = entity.player
	var direction = (player.global_position - entity.global_position).normalized()
	entity.change_direction(direction.x)
	entity.apply_movement(Vector2(direction.x, 0), delta)

func physics_update(_delta: float) -> void:
	pass

func _on_attack_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not body.is_dead:
		transition.emit("AttackMushroomState")
