extends Node2D

@onready var help_text: Label = $Help
@onready var cost_label: Label = $Cost
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var cost: int = 25

var is_close_to_open: bool = false
var is_open: bool = false

func _ready() -> void:
	help_text.visible = false
	cost_label.text = str(cost) + "$"

func _process(_delta: float) -> void:
	if not is_open:
		if is_close_to_open and Input.is_action_just_pressed("Action"):
			if Global.gold >= cost:
				Global.gold -= cost
				Signals.emit_signal("gold_changed")
				open_chest()

func open_chest() -> void:
	is_open = true
	is_close_to_open = false

	$ChestOpenAudio2D.play()
	sprite.play("Open")
	help_text.visible = false
	cost_label.visible = false

	var options: Array[int] = [0, 1]
	if Global.armor < 10:
		options.append(2)

	var choice: int = options[randi() % options.size()]

	var icon: Sprite2D
	match choice:
		0:
			icon = $Sprites/HealthSprite
		1:
			icon = $Sprites/AttackSprite
		2:
			icon = $Sprites/ArmorSprite

	icon.visible = true
	icon.modulate.a = 1.0
	icon.position = Vector2.ZERO

	var tw = icon.create_tween()
	tw.parallel().tween_property(icon, "position:y", icon.position.y - 30, 1.5)
	tw.parallel().tween_property(icon, "modulate:a", 0.0, 1.5)

	Signals.emit_signal("chest_opened", choice)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = true
		is_close_to_open = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = false
		is_close_to_open = false
