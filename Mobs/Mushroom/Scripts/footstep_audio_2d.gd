class_name MushroomFootstepAudio2D
extends AudioStreamPlayer2D

@export var footstep_sound: AudioStream  # один звук, без массива

@export var pitch_range: Vector2 = Vector2(0.95, 1.05) # min, max
@export var volume_offset_range: Vector2 = Vector2(-2.0, 0.0) # min, max в dB
var inspector_volume

func _ready() -> void:
	inspector_volume = volume_db

func play_footstep() -> void:
	if footstep_sound == null:
		push_warning("No footstep sound assigned.")
		return

	stream = footstep_sound
	pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	volume_db = randf_range(volume_offset_range.x, volume_offset_range.y) + inspector_volume
	
	play()
