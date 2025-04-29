extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_test_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Scenes/test_level/test_level.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Scenes/level1/level_1.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	pass # Replace with function body.
