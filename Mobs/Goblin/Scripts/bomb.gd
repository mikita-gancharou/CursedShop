extends RigidBody2D

var damage: int = 30

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var explosion_area: Area2D = $ExplosionArea
@onready var timer: Timer = $Timer

func _ready() -> void:
	explosion_area.monitoring = false
	anim_player.play("Delay")
	$SFX/Fuse.play()
	
	timer.one_shot = true
	timer.start()
	
	timer.timeout.connect(_on_timer_timeout)
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_timer_timeout() -> void:
	anim_player.play("Explode")
	
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Explode":
		queue_free()

func _on_explosion_area_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage, global_position)
