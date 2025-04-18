# Goblin.gd
class_name Goblin
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var damage: int = 20

@onready var healthbar: TextureProgressBar = $"MobHealth/HealthBar"
@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackDirection/AttackArea
@onready var attack_area2: Area2D = $AttackDirection/AttackArea2

@onready var player = get_node("/root/Level1/Player/Player")

var max_health: float = 100.0
var health: float = max_health

var is_blocking: bool = false
var is_dead: bool = false

var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AttackDirection/HitBox/CollisionShape2D.disabled = true
	player = get_node("/root/Level1/Player/Player")
	
	healthbar.max_value = max_health
	healthbar.value = health

func _process(_delta: float) -> void:
	pass

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
