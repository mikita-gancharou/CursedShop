class_name IdleSkeletonState
extends State

func enter(character: CharacterBody2D) -> void:
	owner_character = character
	owner_character.velocity.x = 0
	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.play("Idle")

func exit() -> void:
	pass

func update(delta: float) -> void:
	owner_character.apply_gravity(delta)
	owner_character.apply_velocity(delta)

	# Пример: проверка на расстояние до игрока для скелета
	var player = get_tree().get_first_node_in_group("Player")
	if player and owner_character.global_position.distance_to(player.global_position) < 100:
		transition.emit("ChaseSkeletonState")

func physics_update(delta: float) -> void:
	pass
