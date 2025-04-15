class_name AOEAttackMushroomState
extends State

func enter() -> void:
	entity.animplayer.play("Attack3")
	entity.velocity.x = 0

func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	if entity.player.is_dead:
		transition.emit("IdleMushroomState")
		return
	
	if not entity.animplayer.is_playing():
		transition.emit("IdleMushroomState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func regen() -> void:
	entity.health += 50
	owner.health = min(owner.health, owner.max_health)
	owner.healthbar.value = owner.health

func _on_aoe_attack_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", entity.damage, entity.global_position)
