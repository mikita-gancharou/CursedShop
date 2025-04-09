class_name DamageAudio2D
extends AudioStreamPlayer2D

@export var damage_sounds: Array[AudioStream] = []

func _ready() -> void:
	randomize()  # Инициализация генератора случайных чисел

func play_damage() -> void:
	if damage_sounds.is_empty():
		push_warning("No damage sounds set!")
		return
	
	var random_index: int = randi() % damage_sounds.size()
	stream = damage_sounds[random_index]
	play()
