# player.gd
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0

@onready var sprite: AnimatedSprite2D = $Sprite

@onready var state_machine: StateMachine = $PlayerStateMachine

func _ready() -> void:
	add_to_group("Player")  # Добавляем в группу Player
	state_machine.setup(self)  # Передаем текущий объект (Player)

func _process(delta: float) -> void:
	pass

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
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
	elif sign(direction) == 1:
		sprite.flip_h = false
