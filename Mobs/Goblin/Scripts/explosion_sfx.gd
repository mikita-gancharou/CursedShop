class_name ExplosionAudio2D
extends AudioStreamPlayer2D

@export var explosion_sounds: Array[AudioStream] = []

func _ready() -> void:
	randomize()  # Инициализация генератора случайных чисел

func play_explosion() -> void:
	if explosion_sounds.is_empty():
		push_warning("No Explosion sounds set!")
		return
	
	var random_index: int = randi() % explosion_sounds.size()
	stream = explosion_sounds[random_index]
	play()
