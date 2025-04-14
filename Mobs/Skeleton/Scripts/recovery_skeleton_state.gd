class_name RecoverySkeletonState
extends State

func enter() -> void:
	entity.animplayer.play("Shield_up")
	entity.velocity.x = 0
	owner.is_blocking = true
	
	var player = entity.player
	var direction = (player.global_position - entity.global_position).normalized()
	entity.change_direction(direction.x)

func exit() -> void:
	if owner.health == owner.max_health:
		owner.is_blocking = false

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	owner.health += 1
	owner.healthbar.value = owner.health
	
	if owner.health == owner.max_health:
		transition.emit("IdleSkeletonState")

func physics_update(_delta: float) -> void:
	pass
