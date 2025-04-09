class_name JumpPlayerState
extends State

func enter() -> void:
	entity.animplayer.play("Jump")
	entity.apply_jump()
	
	entity.is_blocking = false
	entity.is_sliding = false
	
	$"../../SFX/JumpAudio2D".play()

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	 
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	#States transition:
	if entity.velocity.y > 10.0:
		transition.emit("FallPlayerState")
	
	if entity.is_on_floor():
		transition.emit("RunningPlayerState")


func physics_update(_delta: float) -> void:
	pass
