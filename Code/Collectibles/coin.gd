extends CharacterBody2D

@export var gravity: float = 500.0

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2(randi_range(-70, 70), -150), 0.3)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		apply_gravity(delta)
	else:
		velocity.x = 0
		$Detector/CollisionShape2D.disabled = false
		
	move_and_slide()

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta


func _on_detector_body_entered(_body: Node2D) -> void:
	if is_on_floor():
		$CoinPickedAudio2D.play()
		Global.gold += 1
		Signals.emit_signal("gold_changed")
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "velocity", Vector2(0, -150), 0.3)
		tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
		
		await get_tree().create_timer(0.5).timeout
		queue_free()
		#or:
		#$CoinPickedAudio2D.connect("finished", Callable(self, "queue_free"))

		
