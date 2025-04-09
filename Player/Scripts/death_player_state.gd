class_name DeathPlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Death")
	entity.velocity.x = 0
	
	entity.is_blocking = false
	entity.is_sliding = false
	
	$"../../SFX/DeathAudio2D".play_death()


func exit() -> void:
	#queue_free()
	pass

func update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
func physics_update(_delta: float) -> void:
	pass
