class_name Skeleton
extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 0.25
@export var gravity: float = 500.0
@export var damage: int = 20
@export var max_health: float = 200.0
@export var is_boss: bool = false
@export var mob_group: int = 0   # 0 — вне групп

@onready var healthbar: TextureProgressBar = $"MobHealth/HealthBar"
@onready var animplayer: AnimationPlayer      = $AnimationPlayer
@onready var sprite: AnimatedSprite2D         = $AnimatedSprite2D
@onready var attack_area: Area2D              = $AttackDirection/AttackArea
@onready var player = get_node("/root/Level1/Player/Player")

var health: float
var is_blocking: bool = false
var is_dead: bool = false
var death_processed: bool = false
var last_player_position: Vector2 = Vector2.ZERO
var has_been_alerted: bool = false

func _ready() -> void:
	# базовая инициализация
	$AttackDirection/HitBox/CollisionShape2D.disabled = true
	health = max_health
	healthbar.max_value = max_health
	healthbar.value     = health

	# подписка на групповой сигнал
	if mob_group != 0:
		Signals.connect("group_alert", Callable(self, "_on_group_alert"))

func _process(_delta: float) -> void:
	if is_dead and not death_processed:
		death_process()

func apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func apply_movement(input_vector: Vector2, _delta: float) -> void:
	velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration)

func apply_velocity(_delta: float) -> void:
	move_and_slide()

func change_direction(direction) -> void:
	if sign(direction) < 0:
		sprite.flip_h = true
		$AttackDirection.rotation_degrees = 180
	elif sign(direction) > 0:
		sprite.flip_h = false
		$AttackDirection.rotation_degrees = 0

func death_process():
	var multiplier = 3 if is_boss else 1
	for i in randi_range(4, 5) * multiplier:
		Signals.emit_signal("enemy_died", position)
	death_processed = true

# вызывается, когда другой моб из группы агрится
func _on_group_alert(group_id: int, _target_pos: Vector2) -> void:
	if mob_group == group_id and not is_dead:
		$SkeletonStateMachine.on_child_transition("ChaseSkeletonState")
