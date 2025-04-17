class_name DamageFlyingState
extends State

var knockback_base: Vector2 = Vector2(20, -50)  # базовая сила отскока (модуль)
var damage_duration: float = 0.5  # длительность состояния урона (секунд)
var damage_timer: float = 0.0  # таймер состояния
var knockback_multiplier: float = 1
@onready var player = get_node("/root/Level1/Player/Player")

func enter() -> void:
	$"../../SFX/DamageAudio2D".play_damage()
	damage_timer = 0.0
		
	
	# Вычисляем направление отскока относительно позиции атакующего врага:
	var direction: int = sign(entity.global_position.x - entity.last_player_position.x)
	if direction == 0:
		direction = 1
	var knockback_force: Vector2 = Vector2(knockback_base.x * direction * knockback_multiplier, knockback_base.y)
	entity.velocity = knockback_force

func exit() -> void:
	entity.velocity = Vector2.ZERO  # сбрасываем скорость
	$"../../AttackDirection/HurtBox/CollisionShape2D".disabled = true
	$"../../AttackDirection/HurtBox/CollisionShape2D".disabled = false
	
func update(delta: float) -> void:
	damage_timer += delta
	if damage_timer >= damage_duration:
		transition.emit("IdleFlyingState")

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
