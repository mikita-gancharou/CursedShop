extends Node2D

var coin_preload = preload("res://Code/Collectibles/coin.tscn")

func _ready():
	Signals.connect("enemy_died", Callable (self, "_on_enemy_death"))
	
	
func _on_enemy_death(enemy_global_position):
	coin_spawn(enemy_global_position)

func coin_spawn(pos):
	var coin = coin_preload.instantiate()
	coin.position = pos
	call_deferred("add_child", coin)
