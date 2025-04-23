extends CharacterBody2D

@export var gravity: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 2.0  # время жизни частицы

func _ready() -> void:
	# 1) Случайный «лавовый» цвет
	var lava_color = Color(
		randf_range(0.9, 1.0),  # R
		randf_range(0.2, 0.5),  # G
		randf_range(0.0, 0.1),  # B
		randf_range(0.7, 1.0)   # A
	)
	$Sprite2D.modulate = lava_color

	# 2) Форсированный фонтан
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2(randi_range(-70, 70), -150), 0.3)

	# 3) Подпишемся на сигнал Area2D (если не сделали в редакторе)
	$Area2D.body_entered.connect(_on_Area2D_body_entered)

	# 4) Авто-удаление через lifetime секунд
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Плавно гасим горизонтальную скорость
		velocity.x = lerp(velocity.x, 0.0, 0.1)
	
	move_and_slide()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not body.is_dead:
		Signals.emit_signal("enemy_attack", damage, global_position)
		# по желанию — тут же удаляем частицу:
		queue_free()
