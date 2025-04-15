class_name State
extends Node

@warning_ignore("unused_signal")
signal transition(new_state_name: StringName)

# Универсальная переменная для любых сущностей
var entity: Node

# Задаем геттер для получения сущности, если это игрок или моб
func get_entity() -> Node:
	return entity

func _ready() -> void:
	await owner.ready
	entity = owner  # Присваиваем родительскую сущность

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
