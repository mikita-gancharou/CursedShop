class_name FallPlayerState
extends State

var landed: bool = false

func enter() -> void:
	landed = false
	entity.animplayer.play("Fall")

func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = entity.get_input_vector()
	entity.apply_movement(input_vector, delta)
	entity.change_direction(input_vector.x)
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	if entity.is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			transition.emit("JumpPlayerState")
		else:
			if not landed:
				landed = true
				entity.animplayer.play("Land")
			elif landed and not entity.animplayer.is_playing():
				transition.emit("RunningPlayerState")

func physics_update(delta: float) -> void:
	pass
