class_name AttackMushroomState
extends State

func enter() -> void:
	print("Attack")
	entity.sprite.play("Attack")
	entity.velocity.x = 0

func exit() -> void:
	pass

func update(delta: float) -> void:
	if not _is_player_in_attack_range():
		transition.emit("ChaseMushroomState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _is_player_in_attack_range() -> bool:
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			return true
	return false
