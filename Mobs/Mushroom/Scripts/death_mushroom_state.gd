class_name DeathMushroomState
extends State


#TODO: queue free, etc
#?гриб падает за пределы экрана?
func enter() -> void:
	entity.animplayer.play("Death")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Применяем гравитацию и движение
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

		
func physics_update(_delta: float) -> void:
	pass
