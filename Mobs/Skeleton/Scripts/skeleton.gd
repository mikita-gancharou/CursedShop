# skeleton.gd
class_name Skeleton
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var damage: int = 20
@export var max_health: float = 200.0
@export var is_boss: bool = false
@export var mob_group: int

@onready var healthbar: TextureProgressBar = $"MobHealth/HealthBar"
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackDirection/AttackArea

@onready var player = get_node("/root/Level1/Player/Player")


var health: float

var is_blocking: bool = false
var is_dead: bool = false
var death_processed: bool = false

var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AttackDirection/HitBox/CollisionShape2D.disabled = true
	player = get_node("/root/Level1/Player/Player")
	
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health

func _process(_delta: float) -> void:
	if is_dead and death_processed == false:
		death_process()

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	return input_vector

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
	var reward_multiplier = 1
	if is_boss:
		reward_multiplier = 3

	for i in randi_range(4, 5) * reward_multiplier:
		Signals.emit_signal("enemy_died", position) # spawn coins

	death_processed = true
