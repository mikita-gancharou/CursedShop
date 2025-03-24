# state.gd
class_name State 
extends Node

signal transition(new_state_name: StringName)

var owner_character: CharacterBody2D

func _ready() -> void:
	await owner.ready
	owner_character = owner as CharacterBody2D

func enter(character: CharacterBody2D) -> void:
	owner_character = character

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
