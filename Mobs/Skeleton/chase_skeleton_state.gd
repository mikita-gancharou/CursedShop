class_name ChaseSkeletonState
extends State

var player: CharacterBody2D  # Ссылка на игрока
var out_of_killzone: float

func enter(character: CharacterBody2D) -> void:
	owner_character = character
	player = get_tree().get_first_node_in_group("Player")  # Получаем первого игрока в группе "Player"
	
	out_of_killzone = owner_character.out_of_killzone 
	
	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.play("Walk")  # Анимация для преследования

func exit() -> void:
	# Здесь можно добавить действия, когда состояние покидается
	pass

func update(delta: float) -> void:
	owner_character.apply_gravity(delta)
	owner_character.apply_velocity(delta)

	# Проверка на расстояние до игрока
	if player:
		var distance = owner_character.global_position.distance_to(player.global_position)
		if distance > out_of_killzone:
			# Если слишком далеко, возвращаемся в Idle состояние
			transition.emit("IdleSkeletonState")
		else:
			# Двигаемся к игроку
			var direction = (player.global_position - owner_character.global_position).normalized()
			owner_character.apply_movement(direction.x, delta)
			owner_character.change_direction(direction.x)

func physics_update(delta: float) -> void:
	pass
