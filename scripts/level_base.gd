extends Node2D

@onready var enemy_container = $EnemyContainer

func _on_enemy_spawned(enemy_instance:Variant):
	#enemy_instance.connect("died", _on_enemy_died)
	enemy_container.add_child(enemy_instance)

func _on_enemy_died():
	pass
