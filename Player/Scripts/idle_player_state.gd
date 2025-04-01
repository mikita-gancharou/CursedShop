class_name IdlePlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Idle")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	#States transition:
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")
		
	if input_vector.x != 0:
		transition.emit("RunningPlayerState")
	
	if Input.is_action_just_pressed("Jump") and owner.is_on_floor():
		transition.emit("JumpPlayerState")
		
	if Input.is_action_just_pressed("Slide") and owner.is_on_floor():
		transition.emit("SlidePlayerState")
	
	if Input.is_action_just_pressed("Attack") and owner.is_on_floor():
		transition.emit("AttackPlayerState")
	
	
func physics_update(delta: float) -> void:
	pass
