class_name DamagePlayerState
extends State

var knockback_base: Vector2 = Vector2(75, -150)  # базовая сила отскока (модуль)
var damage_duration: float = 0.5  # длительность состояния урона (секунд)
var damage_timer: float = 0.0  # таймер состояния

func enter() -> void:
	damage_timer = 0.0
	entity.animplayer.play("Damage")  # проигрываем анимацию получения урона
	
	# Вычисляем направление отскока относительно позиции атакующего врага:
	# Если враг находится слева от игрока, то отскок должен идти вправо, и наоборот.
	var direction: int = sign(entity.global_position.x - entity.last_enemy_position.x)
	# Если вдруг равны или не определено, можно задать направление по умолчанию:
	if direction == 0:
		direction = 1
	var knockback_force: Vector2 = Vector2(knockback_base.x * direction, knockback_base.y)
	entity.velocity = knockback_force

func exit() -> void:
	entity.velocity = Vector2.ZERO  # сбрасываем скорость

func update(delta: float) -> void:
	damage_timer += delta
	if damage_timer >= damage_duration and not entity.animplayer.is_playing():
		transition.emit("IdlePlayerState")  # после анимации возвращаемся в Idle

func physics_update(delta: float) -> void:
	entity.apply_gravity(delta)
	entity.apply_velocity(delta)
