#idle_skeleton_state.gd
class_name IdleSkeletonState
extends State

var into_killzone: float

func enter(character: CharacterBody2D) -> void:
	owner_character = character
	into_killzone = owner_character.into_killzone  
	
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


	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]  
		if owner_character.global_position.distance_to(player.global_position) < into_killzone:
			transition.emit("ChaseSkeletonState")
	else:
		print("No player found in the group.")
	
func physics_update(delta: float) -> void:
	pass
