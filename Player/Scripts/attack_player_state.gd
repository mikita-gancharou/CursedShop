class_name AttackPlayerState
extends State

var combo_stage: int = 0
var next_attack: bool = false

func enter(character: CharacterBody2D) -> void:
	owner_character = character
	
	if owner_character.has_node("Sprite"):
		var sprite = owner_character.get_node("Sprite")
		if sprite is AnimatedSprite2D:
			sprite.animation_finished.connect(_on_attack_finished)
			play_attack_animation()

func exit() -> void:
	combo_stage = 0
	next_attack = false

func play_attack_animation() -> void:
	var sprite = owner_character.get_node("Sprite")
	if sprite is AnimatedSprite2D:
		if combo_stage == 0:
			sprite.play("Attack1")
		elif combo_stage == 1:
			sprite.play("Attack2")
		elif combo_stage == 2:
			sprite.play("Attack3")

func _on_attack_finished() -> void:
	if next_attack and combo_stage < 2:
		combo_stage += 1
		next_attack = false
		play_attack_animation()
	else:
		transition.emit("IdlePlayerState")

func update(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and combo_stage < 2:
		next_attack = true

func physics_update(delta: float) -> void:
	pass
