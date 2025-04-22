class_name DeathSkeletonState
extends State


#TODO: queue free, etc
func enter() -> void:
	entity.animplayer.play("Death")
	$"../../SFX/DeathAudio2D".play_death()
	$"../../MobHealth/AnimationPlayer".play("Healthbar_fadeout")
	entity.velocity.x = 0
	entity.is_dead = true
	
func exit() -> void:
	pass

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

		
func physics_update(_delta: float) -> void:
	pass
