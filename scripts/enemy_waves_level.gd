extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var enemy_spawn_positions = $EnemySpawnPositions

@export var enemy_scene: PackedScene 

@onready var next_wave_timer = $NextWaveTimer
@export var intial_wave_size: int = 1
var wave_counter: int = 0

func _ready():
	spawn_wave(intial_wave_size)
	next_wave_timer.timeout.connect(_on_next_wave_timeout)

func _on_enemy_died():
	pass

func spawn_enemy():
	var spawn_positions_array = enemy_spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 
	var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))
	var enemy_instance = enemy_scene.instantiate()

	enemy_instance.global_position = random_spawn_position.global_position + offset
	enemy_container.add_child(enemy_instance)

func spawn_wave(num_enemies: int):
	wave_counter += 1
	for i in num_enemies:
		spawn_enemy()
	
func _on_next_wave_timeout():
	spawn_wave(intial_wave_size + (wave_counter % 5))