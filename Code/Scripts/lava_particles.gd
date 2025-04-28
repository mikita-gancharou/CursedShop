extends CharacterBody2D
class_name LavaParticle

var grounded := false
var fade_timer := 0.0

var gravity := 500.0
var fade_time := 1.0
var damage := 10

@onready var light: PointLight2D = $PointLight2D

func init(initial_velocity: Vector2, gravity_val: float, fade_time_val: float, damage_val: int) -> void:
	velocity = initial_velocity
	gravity = gravity_val
	fade_time = fade_time_val
	damage = damage_val

func _ready() -> void:
	# Создаем случайный цвет для частицы
	$Sprite2D.modulate = Color(
		randf_range(0.9, 1.0),
		randf_range(0.2, 0.5),
		randf_range(0.0, 0.1),
		randf_range(0.7, 1.0)
	)

	light.position = Vector2(0, 0) # Устанавливаем позицию света относительно частицы
	light.color = $Sprite2D.modulate
	light.enabled = true
	light.energy = 0.5 # Интенсивность свечения

	$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if grounded:
		velocity.x = lerp(velocity.x, 0.0, 5.0 * delta)
		fade_timer += delta

		var alpha = clamp(1.0 - fade_timer / fade_time, 0.0, 1.0)
		var mod_color = $Sprite2D.modulate
		mod_color.a = alpha
		$Sprite2D.modulate = mod_color

		# Уменьшаем интенсивность свечения
		light.energy = lerp(0.5, 0.0, fade_timer / fade_time)

		if fade_timer >= fade_time:
			queue_free()
	else:
		velocity.y += gravity * delta

	move_and_slide()

	if not grounded and is_on_floor():
		grounded = true
		$Area2D.monitoring = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not body.is_dead:
		Signals.emit_signal("lava_attack", damage, global_position)
		queue_free()
