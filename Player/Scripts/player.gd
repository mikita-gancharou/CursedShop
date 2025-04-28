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

var is_sliding: bool = false
var is_blocking: bool = false
var is_dead: bool = false
var is_on_lava: bool = false
var is_respawn: bool = false

var last_enemy_position: Vector2 = Vector2.ZERO #TODO: refactor

@onready var animplayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $CanvasLayer/HealthBar
@onready var healthbar_text = $CanvasLayer/HealthBar/Label
@onready var gold_label = $CanvasLayer/VBoxContainer/Gold/Amount
@onready var attack_label = $CanvasLayer/VBoxContainer/Attack/Amount
@onready var armor_label = $CanvasLayer/VBoxContainer/Armor/Amount

var spawn_gold: int
var spawn_damage: int
var spawn_armor: int
var spawn_maxhp: int
var spawn_position


func _ready() -> void:
	add_to_group("Player")
	
	if not is_respawn:
		Global.gold = 0
		Global.damage = 50
		Global.armor = 0
		max_health = 100
		health = max_health
	else:
		Global.gold = spawn_gold
		Global.damage = spawn_damage
		Global.armor = spawn_armor
		max_health = spawn_maxhp
		health = max_health
		
		global_position = spawn_position
	
	healthbar.max_value = max_health
	healthbar.value = health
	healthbar_text.text = str(health) + "/" + str(max_health)
	
	attack_label.text = str(Global.damage)
	
	$BgMusic.play()

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


func _on_respawn_area_area_entered(area: Area2D) -> void:
	
	spawn_gold = Global.gold
	spawn_damage = Global.damage
	spawn_armor = Global.armor
	spawn_maxhp = max_health
	spawn_position = $"../../TileMapLayer/Respawns/RespawnArea".global_position
