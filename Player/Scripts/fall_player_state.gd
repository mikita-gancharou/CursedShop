class_name FallPlayerState
extends State

func enter() -> void:
	entity.sprite.play("Fall")

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	 
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

	if entity.is_on_floor():
		transition.emit("IdlePlayerState")
		
func physics_update(delta: float) -> void:
	pass
