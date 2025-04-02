class_name ChaseSkeletonState
extends State

func enter() -> void:
	entity.animplayer.play("Run")
	entity.attack_area.body_entered.connect(_on_attack_area_entered)

func exit() -> void:
	entity.attack_area.body_entered.disconnect(_on_attack_area_entered)

func update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		var direction = (player.global_position - entity.global_position).normalized()
		
		entity.change_direction(direction.x)
		entity.apply_movement(Vector2(direction.x, 0), delta)
		
	else:
		print("Player not found")
		transition.emit("IdleSkeletonState")
		return

func physics_update(_delta: float) -> void:
	pass

func _on_attack_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		transition.emit("AttackSkeletonState")
