# fall_player_state.gd
class_name FallPlayerState
extends State


func enter(character: CharacterBody2D) -> void:
	owner_character = character
	
	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.play("Fall")


func exit() -> void:
	pass

func update(delta: float) -> void:
	var sprite = owner_character.get_node("Sprite")
	var input_vector = owner_character.get_input_vector()
	
	owner_character.apply_movement(input_vector, delta)
	owner_character.change_direction(input_vector.x)
	
	owner_character.apply_gravity(delta)
	owner_character.apply_velocity(delta)

	if owner_character.is_on_floor():
		sprite.play("Land")
		await sprite.animation_finished
		transition.emit("IdlePlayerState")
	
func physics_update(delta: float) -> void:
	pass
