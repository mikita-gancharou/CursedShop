class_name DeathPlayerState
extends State

func enter() -> void:
	print("Player is dead, gameover")
	entity.animplayer.play("Death")
	entity.velocity.x = 0
	
	entity.is_blocking = false
	entity.is_sliding = false

func exit() -> void:
	#queue_free()
	pass

func update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
func physics_update(delta: float) -> void:
	pass
