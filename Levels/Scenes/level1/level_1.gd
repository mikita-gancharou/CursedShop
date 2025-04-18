extends Node2D

var damage: int = 40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_lava_area_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)

func _on_lava_area_2_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)

func _on_lava_area_3_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_4_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_5_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_6_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_7_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_8_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_9_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_10_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_11_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_12_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_13_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)


func _on_lava_area_14_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)
