# skeleton.gd
class_name Skeleton
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var damage: int = 20

var health: int = 100

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackDirection/AttackArea

var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AttackDirection/HitBox/CollisionShape2D.disabled = true

func _process(delta: float) -> void:
	pass

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	#input_vector.x = Input.get_axis("Move_Left", "Move_Right")
	return input_vector

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(input_vector: Vector2, delta: float) -> void:
	velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration)

func apply_velocity(delta: float) -> void:
	move_and_slide()

func change_direction(direction) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif sign(direction) == 1:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0
