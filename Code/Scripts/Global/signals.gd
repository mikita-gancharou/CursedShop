extends Node

@warning_ignore("unused_signal")
signal enemy_attack(enemy_damage, enemy_global_position)

@warning_ignore("unused_signal")
signal lava_attack(enemy_damage, enemy_global_position)

@warning_ignore("unused_signal")
signal player_attack(player_damage, player_global_position)

@warning_ignore("unused_signal")
signal enemy_died(enemy_global_position)

@warning_ignore("unused_signal")
signal gold_changed()

@warning_ignore("unused_signal")
signal chest_opened(boost_type)

@warning_ignore("unused_signal")
signal group_alert(group_id: int, target_pos: Vector2)
