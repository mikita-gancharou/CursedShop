class_name DamagePlayerState
extends State

var knockback_base: Vector2 = Vector2(40, -100)  # базовая сила отскока (модуль)
var damage_duration: float = 0.5  # длительность состояния урона (секунд)
var damage_timer: float = 0.0  # таймер состояния
var knockback_multiplier: float = 1.0

func enter() -> void:
	damage_timer = 0.0
	
	if entity.is_sliding:
		knockback_multiplier = 0
	if entity.is_blocking:
		knockback_multiplier = 0.2
		damage_duration = 0.1
	else:
		$"../../SFX/DamageAudio2D".play_damage()
		knockback_multiplier = 0.7
		damage_duration = 0.4
		entity.animplayer.play("Damage")


	var direction: int = sign(entity.global_position.x - entity.last_enemy_position.x)
	# Если вдруг равны или не определено, можно задать направление по умолчанию:
	if direction == 0:
		direction = 1
	var knockback_force: Vector2 = Vector2(knockback_base.x * direction * knockback_multiplier, knockback_base.y * knockback_multiplier)
	entity.velocity = knockback_force

func exit() -> void:
	entity.velocity = Vector2.ZERO
	$"../../AttackDirection/HurtBox/CollisionShape2D".set_deferred("disabled", true)
	$"../../AttackDirection/HurtBox/CollisionShape2D".set_deferred("disabled", false)
	
func update(delta: float) -> void:
	damage_timer += delta
	if damage_timer >= damage_duration:
		if entity.is_blocking:
			transition.emit("BlockPlayerState")
		else:
			transition.emit("RunningPlayerState") 

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
