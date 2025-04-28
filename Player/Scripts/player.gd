# Player.gd

class_name Player
extends CharacterBody2D

# ─────────────────────────────────────────────────────────────────────────────
# Movement & physics
@export var speed: float = 200.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var jump_velocity: float = 300.0

func get_input_vector() -> Vector2:
	var iv = Vector2.ZERO
	iv.x = Input.get_axis("Move_Left", "Move_Right")
	return iv

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(iv: Vector2, _delta: float) -> void:
	velocity.x = lerp(velocity.x, iv.x * speed, acceleration)

func apply_velocity(_delta: float) -> void:
	move_and_slide()

func apply_jump() -> void:
	velocity.y = -jump_velocity

func change_direction(dir: float) -> void:
	if dir < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif dir > 0:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0

# ─────────────────────────────────────────────────────────────────────────────
# State
var is_sliding: bool = false
var is_blocking: bool = false
var is_dead: bool = false

var last_enemy_position: Vector2 = Vector2.ZERO

# ─────────────────────────────────────────────────────────────────────────────
# Health & UI
var health: int
var max_health: int = 100

# ─────────────────────────────────────────────────────────────────────────────
# Checkpoint data
var spawn_position: Vector2 = Vector2.ZERO
var spawn_gold:     int = 0
var spawn_damage:   int = 0
var spawn_armor:    int = 0
var spawn_maxhp:    int = 0

# ─────────────────────────────────────────────────────────────────────────────
# Nodes
@onready var animplayer: AnimationPlayer       = $AnimationPlayer
@onready var sprite: AnimatedSprite2D          = $AnimatedSprite2D
@onready var healthbar: TextureProgressBar     = $CanvasLayer/HealthBar
@onready var healthbar_text: Label            = $CanvasLayer/HealthBar/Label
@onready var gold_label: Label                = $CanvasLayer/VBoxContainer/Gold/Amount
@onready var attack_label: Label              = $CanvasLayer/VBoxContainer/Attack/Amount
@onready var armor_label: Label               = $CanvasLayer/VBoxContainer/Armor/Amount
@onready var bg_music: AudioStreamPlayer2D    = $BgMusic

# ─────────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	add_to_group("Player")

	# 1) Инициализируем стартовый чекпоинт (уровень начальной позиции)
	spawn_position = global_position

	spawn_gold   = 0
	Global.gold  = 0

	spawn_damage   = 50
	Global.damage  = 50

	spawn_armor   = 0
	Global.armor  = 0

	spawn_maxhp   = max_health
	health       = max_health

	_update_ui()
	bg_music.play()

func _process(_delta: float) -> void:
	pass  # движение и гравитацию обрабатывают ваши стейты

# ─────────────────────────────────────────────────────────────────────────────
func _update_ui() -> void:
	healthbar.max_value = max_health
	healthbar.value     = health
	healthbar_text.text = "%d/%d" % [health, max_health]
	gold_label.text     = str(Global.gold)
	attack_label.text   = str(Global.damage)
	armor_label.text    = str(Global.armor)

# ─────────────────────────────────────────────────────────────────────────────
func save_checkpoint(pos: Vector2) -> void:
	# Вызывается из RespawnArea при входе туда
	spawn_position = pos

func respawn() -> void:
	# Вызывается из DeathPlayerState после таймера
	is_dead       = false
	health        = max_health

	global_position = spawn_position
	velocity        = Vector2.ZERO

	_update_ui()
