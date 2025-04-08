# player.gd

#TODO: check footsteps in animation player

class_name Player
extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var jump_velocity: float = 300.0

var health: int
var max_health: int = 100
var damage: int = 50

var is_sliding: bool = false
var is_blocking: bool = false

var last_enemy_position: Vector2 = Vector2.ZERO #TODO: refactor

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $CanvasLayer/HealthBar

func _ready() -> void:
	add_to_group("Player")
	health = max_health
	healthbar.max_value = max_health
	healthbar.value = health

func _process(_delta: float) -> void:
	pass

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("Move_Left", "Move_Right")
	return input_vector

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(input_vector: Vector2, _delta: float) -> void:
	velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration)

func apply_velocity(_delta: float) -> void:
	move_and_slide()

func apply_jump() -> void:
	velocity.y -= jump_velocity

func change_direction(direction) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif sign(direction) == 1:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0
