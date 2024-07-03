extends Node2D

signal enemy_spawned(enemy_instance)

@export var enemy_scene: PackedScene 

@onready var timer = $Timer
@onready var spawn_positions = $SpawnPositions

func _ready():
	pass

func _on_timeout():
	print("spawning enemy")
	spawn_enemy()

func spawn_enemy():    
	var spawn_positions_array = spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 

	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = random_spawn_position.global_position

	emit_signal("enemy_spawned", enemy_instance)
