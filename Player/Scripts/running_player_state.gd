# running_player_state.gd
class_name RunningPlayerState
extends State


func enter(character: CharacterBody2D) -> void:
	owner_character = character
	
	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.play("Run")


func exit() -> void:
	pass

func update(delta: float) -> void:
	var input_vector = owner_character.get_input_vector()

	owner_character.apply_movement(input_vector, delta)
	owner_character.change_direction(input_vector.x)
	
	owner_character.apply_gravity(delta)
	owner_character.apply_velocity(delta)
	
	if input_vector.x == 0 and owner_character.is_on_floor():
		transition.emit("IdlePlayerState")

	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		transition.emit("JumpPlayerState")
	
	if owner_character.velocity.y > 10.0:
		transition.emit("FallPlayerState")
		
func physics_update(delta: float) -> void:
	pass
