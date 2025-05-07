extends Node2D

var damage: int = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.is_mobile:
		$Labels/Tutorial_2.visible = false
		$Labels/Tutorial_3.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_lava_area_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)
