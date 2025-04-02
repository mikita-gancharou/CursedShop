class_name BlockPlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Block")
	entity.velocity.x = 0
	
	entity.is_blocking = true
	entity.is_sliding = false
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	# State transitions:
	if entity.velocity.y > 20.0:
		transition.emit("FallPlayerState")
	
	if not Input.is_action_pressed("Block"):
		if input_vector.x != 0:
			transition.emit("RunningPlayerState")
		if Input.is_action_just_pressed("Jump") and owner.is_on_floor():
			transition.emit("JumpPlayerState")
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("Slide") and owner.is_on_floor():
		transition.emit("SlidePlayerState")
	
	if Input.is_action_just_pressed("Attack") and owner.is_on_floor():
		transition.emit("AttackPlayerState")
			
	if Input.is_action_just_pressed("Ultimative") and owner.is_on_floor():
		transition.emit("UltimativePlayerState")


func physics_update(_delta: float) -> void:
	pass
