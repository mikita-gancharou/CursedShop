class_name JumpAudio2D
extends AudioStreamPlayer2D

func play_jump() -> void:
	play()

func get_footstep_type() -> void:
			var cell: Vector2i = t.local_to_map(t.to_local(global_position))
			var data: TileData = t.get_cell_tile_data(cell)
			if data:
				var type = data.get_custom_data("footstep_type")
				if type == null:
					continue
				stream_randomizer.set_stream(0, footstep_variants[type])
