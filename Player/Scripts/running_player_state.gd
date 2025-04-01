class_name RunningPlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Run")

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	#States transition:
	if input_vector.x == 0:
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("Jump") and owner.is_on_floor():
		transition.emit("JumpPlayerState")
	
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")
	
	if Input.is_action_just_pressed("Slide") and owner.is_on_floor():
		transition.emit("SlidePlayerState")
	
	if Input.is_action_just_pressed("Attack") and owner.is_on_floor():
		transition.emit("AttackPlayerState")
	
func physics_update(delta: float) -> void:
	pass
