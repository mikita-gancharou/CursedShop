class_name Skeleton
extends CharacterBody2D

@export var speed: float = 50.0
@export var acceleration: float = 0.2
@export var gravity: float = 500.0

@export var into_killzone: float = 200.0
@export var out_of_killzone: float = 300.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var state_machine: SkeletonStateMachine = $SkeletonStateMachine  # Указываем правильный тип

func _ready() -> void:
	state_machine.setup(self)  # Передаем текущий объект (Skeleton)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_movement(direction: float, delta: float) -> void:
	velocity.x = lerp(velocity.x, direction * speed, acceleration)

func apply_velocity(delta: float) -> void:
	move_and_slide()

func change_direction(direction) -> void:
	if sign(direction) == -1:
		sprite.flip_h = true
	elif sign(direction) == 1:
		sprite.flip_h = false
