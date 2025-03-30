class_name RunningentityState
extends State

func enter() -> void:
	entity.sprite.play("Run")

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	if input_vector.x == 0:
		transition.emit("IdlePlayerState")

func physics_update(delta: float) -> void:
	pass
