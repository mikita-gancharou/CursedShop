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
		var landed = sprite.animation_finished
		
		# Позволяем прыгнуть, даже если началась анимация приземления
		while not landed:
			if owner_character.is_jump_pressed():
				transition.emit("JumpPlayerState")
				return
			await get_tree().process_frame
	
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("slide") and owner.is_on_floor():
		transition.emit("SlidePlayerState")
	
func physics_update(delta: float) -> void:
	pass
