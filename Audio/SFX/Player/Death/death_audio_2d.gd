class_name DeathAudio2D
extends AudioStreamPlayer2D

@export var death_sounds: Array[AudioStream] = []

func _ready() -> void:
	randomize()  # Инициализация генератора случайных чисел

func play_death() -> void:
	if death_sounds.is_empty():
		push_warning("No death sounds set!")
		return
	
	var random_index: int = randi() % death_sounds.size()
	stream = death_sounds[random_index]
	play()
