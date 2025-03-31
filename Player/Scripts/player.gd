# player.gd
class_name Player
extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var jump_velocity: float = 200.0
@export var health: int = 100

var last_enemy_position: Vector2 = Vector2.ZERO #TODO: refactor

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("Player")

func _process(delta: float) -> void:
	pass

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("Move_Left", "Move_Right")
	return input_vector

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(input_vector: Vector2, delta: float) -> void:
	velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration)

func apply_velocity(delta: float) -> void:
	move_and_slide()

func apply_jump() -> void:
	velocity.y -= jump_velocity

func change_direction(direction) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
	elif sign(direction) == 1:
		sprite.flip_h = false
