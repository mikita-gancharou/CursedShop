extends Node2D

@export var lava_particle_scene: PackedScene
@export var spawn_interval: float = 0.2

# Мы попытаемся найти узел SpawnPoint, если его нет — Marker2D
var spawn_point: Marker2D
@onready var spawn_timer: Timer = $Timer

func _ready() -> void:
	# Ищем точку спавна
	if has_node("SpawnPoint"):
		spawn_point = get_node("SpawnPoint") as Marker2D
	elif has_node("Marker2D"):
		spawn_point = get_node("Marker2D") as Marker2D
	else:
		push_warning("No spawn point found in LavaFountain, expected SpawnPoint or Marker2D")

	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.start()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	if not spawn_point:
		return
	# Инстанцируем частицу из сцены и ставим в точку спавна
	var p = lava_particle_scene.instantiate()
	get_parent().add_child(p)
	p.global_position = spawn_point.global_position
