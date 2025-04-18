class_name DamageGoblinState
extends State

var knockback_base: Vector2 = Vector2(20, -100)  # базовая сила отскока (модуль)
var damage_duration: float = 0.5  # длительность состояния урона (секунд)
var damage_timer: float = 0.0  # таймер состояния

func enter() -> void:
	entity.animplayer.play("Damage")
	$"../../SFX/DamageAudio2D".play_damage()
	
	damage_timer = 0.0
	entity.animplayer.animation_finished.connect(_on_animation_finished)
	
	# Вычисляем направление отскока относительно позиции атакующего врага:
	var direction: int = sign(entity.global_position.x - entity.last_player_position.x)
	if direction == 0:
		direction = 1
	var knockback_force: Vector2 = Vector2(knockback_base.x * direction, knockback_base.y)
	entity.velocity = knockback_force

func exit() -> void:
	entity.velocity = Vector2.ZERO  # сбрасываем скорость
	entity.animplayer.animation_finished.disconnect(_on_animation_finished)
	$"../../AttackDirection/HurtBox/CollisionShape2D".disabled = true
	$"../../AttackDirection/HurtBox/CollisionShape2D".disabled = false
	
func update(delta: float) -> void:
	damage_timer += delta
	if damage_timer >= damage_duration:
		transition.emit("IdleGoblinState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Damage":
		transition.emit("IdleGoblinState")
