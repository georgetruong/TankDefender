extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var enemy_spawn_positions = $EnemySpawnPositions

@export var enemy_scene: PackedScene 
@export var soldier_scene: PackedScene 

var health_pickup_scene = preload("res://scenes/health_pickup.tscn")
@onready var pickups_container = $PickupsContainer

@onready var ui_layer = $UILayer
@onready var hud = $UILayer/HUD

@export var wave_time = 30
@export var initial_wave_size: int = 1
var wave_counter: int = 0
var wave_timer = null
var wave_time_left

func _ready():
	init_wave_timer()
	spawn_wave(initial_wave_size)

func _process(delta):
	if enemies_left() == 0:
		spawn_wave(initial_wave_size + (wave_counter / 5))
	update_hud()

func _on_enemy_died():
	pass

func init_wave_timer():
	wave_time_left = wave_time
	hud.set_time_label(wave_time_left)

	wave_timer = Timer.new()
	wave_timer.name = "WaveTimer"
	wave_timer.wait_time = 1
	wave_timer.timeout.connect(_on_wave_timeout)
	add_child(wave_timer)
	wave_timer.start()

func spawn_enemy():
	var spawn_positions_array = enemy_spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 
	var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))

	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = random_spawn_position.global_position + offset
	enemy_instance.connect("spawned_health_pickup", _on_spawned_health_pickup)
	enemy_container.add_child(enemy_instance)

func spawn_soldier():
	var spawn_positions_array = enemy_spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 
	var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))

	var soldier_instance = soldier_scene.instantiate()
	soldier_instance.global_position = random_spawn_position.global_position + offset
	soldier_instance.connect("spawned_health_pickup", _on_spawned_health_pickup)
	enemy_container.add_child(soldier_instance)

func spawn_wave(num_enemies: int):
	wave_counter += 1
	wave_time_left = wave_time
	hud.set_time_label(wave_time_left)
	for i in num_enemies:
		spawn_enemy()
		#spawn_soldier()
	
func _on_wave_timeout():
	wave_time_left -= 1
	if wave_time_left <= 0:
		spawn_wave(initial_wave_size + int(wave_counter / 5))
		update_hud()

func enemies_left() -> int:
	return enemy_container.get_children().size()

func update_hud():
	hud.set_wave_label(wave_counter)
	hud.set_enemies_left_label(enemies_left())
	hud.set_time_label(wave_time_left)

func _on_spawned_health_pickup(spawn_pos):
	var pickup_inst = health_pickup_scene.instantiate()
	pickup_inst.global_position = spawn_pos
	pickups_container.call_deferred("add_child", pickup_inst)