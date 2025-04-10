extends Area2D

var healing: int = 50
var amplitude: float = 2.0   # максимальное отклонение по Y
var frequency: float = 0.4    # колебаний в секунду

var initial_position: Vector2
var time_passed: float = 0.0

func _ready() -> void:
	initial_position = position

func _process(delta: float) -> void:
	time_passed += delta
	# Меняем позицию относительно начальной по синусоиде
	position.y = initial_position.y + amplitude * sin(time_passed * frequency * TAU)

func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Player:
		body.get_node("PlayerStateMachine").add_health(healing)
		$PotionUsedAudio2D.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.visible = false
		$PotionUsedAudio2D.connect("finished", Callable(self, "queue_free"))
