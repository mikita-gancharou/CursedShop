class_name RecoverySkeletonState
extends State

func enter() -> void:
	entity.animplayer.play("Shield_up")
	entity.velocity.x = 0
	entity.is_blocking = true
	
	var player = entity.player
	var direction = (player.global_position - entity.global_position).normalized()
	entity.change_direction(direction.x)

func exit() -> void:
	if entity.health == entity.max_health:
		entity.is_blocking = false

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# Увеличиваем здоровье с учётом delta
	entity.health += 50 * delta
	entity.health = min(entity.health, entity.max_health)
	entity.healthbar.value = entity.health
	

	if entity.health >= entity.max_health:
		transition.emit("IdleSkeletonState")

func physics_update(_delta: float) -> void:
	pass
