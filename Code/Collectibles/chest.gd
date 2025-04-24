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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_open:
		if is_close_to_open and Input.is_action_just_pressed("Action"):
			if Global.gold >= cost:
				Global.gold -= cost
				Signals.emit_signal("gold_changed")
				open_chest()

func open_chest():
	is_open = true
	is_close_to_open = false
	
	sprite.play("Open")
	help_text.visible = false
	cost_label.visible = false
	Signals.emit_signal("chest_opened")
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = true
		is_close_to_open = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = false
		is_close_to_open = false
