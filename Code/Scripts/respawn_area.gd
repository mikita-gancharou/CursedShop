# RespawnArea.gd
extends Area2D
class_name RespawnArea

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	# Только реагируем на игрока
	if body is Player:
		body.save_checkpoint(global_position)
