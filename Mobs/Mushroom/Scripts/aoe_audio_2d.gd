class_name AOEAudio2D
extends AudioStreamPlayer2D

@export var AOE_sounds: Array[AudioStream] = []

func _ready() -> void:
	randomize()  # Инициализация генератора случайных чисел

func play_AOE() -> void:
	if AOE_sounds.is_empty():
		push_warning("No AOE sounds set!")
		return
	
	var random_index: int = randi() % AOE_sounds.size()
	stream = AOE_sounds[random_index]
	play()
