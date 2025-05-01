class_name AttackMushroomState
extends State

var has_attacked: bool = false
var combo: bool = false
var played_recover: bool = false

func enter() -> void:
	entity.velocity.x = 0
	has_attacked = false
	combo = true
	played_recover = false
	entity.animplayer.play("Attack1")

func exit() -> void:
	has_attacked = false
	combo = false
	played_recover = false

func update(_delta: float) -> void:
	if entity.player.is_dead:
		transition.emit("IdleMushroomState")
		return

	if not entity.animplayer.is_playing():
		# Если это босс и Recover ещё не проиграна — проигрываем её
		if entity.is_boss and not played_recover:
			entity.animplayer.play("Recover")
			played_recover = true
			return

		if not _is_player_in_attack_range():
			if _is_player_in_aoe_range() and entity.health < entity.max_health:
				transition.emit("AOEAttackMushroomState")
			else:
				transition.emit("ChaseMushroomState")
		else:
			has_attacked = false
			if combo:
				entity.animplayer.play("Attack2")
				combo = false
			else:
				entity.animplayer.play("Attack1")
				combo = true
			played_recover = false  # Сброс флага, чтобы снова проиграть Recover

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _is_player_in_attack_range() -> bool:
	for body in entity.attack_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _is_player_in_aoe_range() -> bool:
	for body in entity.aoe_area.get_overlapping_bodies():
		if body.is_in_group("Player") and not body.is_dead:
			return true
	return false

func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)
