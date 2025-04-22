class_name Mushroom
extends CharacterBody2D

@export var base_speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var damage: int = 20

var speed: float

var max_health: float = 300.0
var health: float = max_health

var is_blocking: bool = false
var is_dead: bool = false
var death_processed: bool = false

var last_player_position: Vector2 = Vector2.ZERO

@onready var healthbar: TextureProgressBar = $"MobHealth/HealthBar"
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $"AttackDirection/AttackArea"
@onready var aoe_area: Area2D = $"AttackDirection/AOETrigger"
@onready var player = get_node("/root/Level1/Player/Player")

func _ready() -> void:
	$AttackDirection/HitBox/CollisionShape2D.disabled = true
	# Инициализируем вариативную скорость ±10%
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	speed = base_speed * rng.randf_range(0.9, 1.1)

	healthbar.max_value = max_health
	healthbar.value = health

func _process(_delta: float) -> void:
	if is_dead and death_processed == false:
		death_process()

func get_input_vector() -> Vector2:
	return Vector2.ZERO

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(input_vector: Vector2, _delta: float) -> void:
	velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration)

func apply_velocity(_delta: float) -> void:
	move_and_slide()

func change_direction(direction) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif sign(direction) == 1:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0

func death_process():
	for i in randi_range(3,5):
		Signals.emit_signal("enemy_died", position) #spawn coins
	death_processed = true
