extends Node2D
class_name LavaFountain

@export var lava_particle_scene: PackedScene
@export var spawn_interval_min: float = 0.05
@export var spawn_interval_max: float = 0.2
@export var fountain_force: float = 250.0
@export var fountain_spread: float = 100.0
@export var gravity: float = 500.0
@export var lifetime: float = 2.0
@export var fade_time: float = 1.0
@export var damage: int = 10
@export var sleep_time: float = 1.5

var spawn_accumulator: float = 0.0
var particles: Array = []
var is_sleeping := false
var current_spawn_interval: float
var sleep_timer: float = 0.0

@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	_reset_spawn_interval()

func _physics_process(delta: float) -> void:
	if is_sleeping:
		sleep_timer += delta
		if sleep_timer >= sleep_time:
			sleep_timer = 0.0
			is_sleeping = false
			_reset_spawn_interval()
		return

	spawn_accumulator += delta
	while spawn_accumulator >= current_spawn_interval:
		_spawn_particle()
		spawn_accumulator -= current_spawn_interval
		_reset_spawn_interval()

	# Удаляем устаревшие частицы
	for i in range(particles.size() - 1, -1, -1):
		var info = particles[i]
		var p = info["node"]
		if not is_instance_valid(p):
			particles.remove_at(i)
			continue

		info["time"] -= delta
		if info["time"] <= 0.0:
			p.queue_free()
			particles.remove_at(i)

func _spawn_particle() -> void:
	var p = lava_particle_scene.instantiate() as LavaParticle
	add_child(p)
	p.global_position = spawn_point.global_position

	var velocity = Vector2(
		randf_range(-fountain_spread, fountain_spread),
		-fountain_force
	)

	p.init(velocity, gravity, fade_time, damage)

	particles.append({
		"node": p,
		"time": lifetime
	})

	# Шанс "уснуть" после спавна частицы
	if randf() < 0.1:  # 10% шанс
		is_sleeping = true

func _reset_spawn_interval() -> void:
	current_spawn_interval = randf_range(spawn_interval_min, spawn_interval_max)
