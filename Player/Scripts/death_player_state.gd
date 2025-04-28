# DeathPlayerState.gd

class_name DeathPlayerState
extends State

var respawn_timer := 1.5

func enter() -> void:
	entity.animplayer.play("Death")
	$"../../SFX/DeathAudio2D".play_death()
	entity.velocity.x = 0
	entity.is_dead     = true
	respawn_timer      = 1.5

func update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	if entity.is_dead:
		respawn_timer -= delta
		if respawn_timer <= 0.0:
			entity.respawn()
			transition.emit("IdlePlayerState")
