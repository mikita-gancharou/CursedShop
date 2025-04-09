class_name AttackAudio2D
extends AudioStreamPlayer2D

@export var attack_sounds: Array[AudioStream] = []

func play_attack(index: int) -> void:
	if index < 0 or index >= attack_sounds.size():
		push_warning("Invalid attack sound index: %d" % index)
		return
	
	stream = attack_sounds[index]
	play()
