extends Node2D

@onready var help_text: Label
@onready var final_text: Label = $Final
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var cost: int = 0
#@export var coin_spawn_count: int = 200  # сколько всего монет сыпать
@export var coin_spawn_delay: float = 0.1  # интервал между монетами

var is_close_to_open: bool = false
var is_open: bool = false
var is_spawning: bool = false

func _ready() -> void:
	if Global.is_mobile:
		help_text = $HelpMobile
	else:
		help_text = $HelpPC

func _process(_delta: float) -> void:
	if not is_open and is_close_to_open and Input.is_action_just_pressed("Action"):
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
	final_text.visible = true

	if not is_spawning:
		is_spawning = true
		spawn_coins()


func spawn_coins() -> void:
	await get_tree().process_frame  # подождём один кадр для надёжности
	while(true):
		Signals.emit_signal("enemy_died", position)
		await get_tree().create_timer(coin_spawn_delay).timeout


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = true
		is_close_to_open = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if not is_open:
		help_text.visible = false
		is_close_to_open = false
