extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var enemy_spawn_positions = $EnemySpawnPositions

@export var enemy_scene: PackedScene 
@export var intial_wave_size: int = 3

func _ready():
	spawn_wave(intial_wave_size)

func _on_enemy_died():
	pass

func spawn_enemy():
	var spawn_positions_array = enemy_spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 
	var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))
	var enemy_instance = enemy_scene.instantiate()

	enemy_instance.global_position = random_spawn_position.global_position + offset
	#enemy_instance.connect("died", _on_enemy_died)
	enemy_container.add_child(enemy_instance)

func spawn_wave(num_enemies: int):
	for i in num_enemies:
		spawn_enemy()
	