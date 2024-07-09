extends Node2D

@onready var enemy_container = $EnemyContainer
@onready var enemy_spawn_positions = $EnemySpawnPositions

@export var tank_scene: PackedScene 
@export var soldier_scene: PackedScene 

var health_pickup_scene = preload("res://scenes/health_pickup.tscn")
@onready var pickups_container = $PickupsContainer

@onready var ui_layer = $UILayer
@onready var hud = $UILayer/HUD
@onready var game_over_screen = $UILayer/GameOverScreen
@onready var menu_screen = $UILayer/MenuScreen

@export var wave_time = 30
@export var initial_wave_size: int = 1
var wave_counter: int = 0
var wave_timer = null
var wave_time_left

var score = 0

@onready var player_camera = $Camera2D

func _ready():
	score = 0
	init_wave_timer()
	spawn_wave()

func _process(delta):
	if enemies_left() == 0:
		spawn_wave()
	update_hud()

	if Input.is_action_just_pressed("menu"):
		toggle_show_menu(true)

func toggle_show_menu(_show_flag: bool):
	if _show_flag:
		hud.hide()
		get_tree().paused = true
		menu_screen.show()
	else:
		hud.show()
		get_tree().paused = false
		menu_screen.hide()

func init_wave_timer():
	wave_time_left = wave_time
	hud.set_time_label(wave_time_left)

	wave_timer = Timer.new()
	wave_timer.name = "WaveTimer"
	wave_timer.wait_time = 1
	wave_timer.timeout.connect(_on_wave_timeout)
	add_child(wave_timer)
	wave_timer.start()

func spawn_enemy(_type = "soldier"):
	var spawn_positions_array = enemy_spawn_positions.get_children()
	var random_spawn_position = spawn_positions_array.pick_random() 
	var offset = Vector2(randf_range(-25, 25), randf_range(-25, 25))

	var enemy_inst
	if _type == "soldier":
		enemy_inst = soldier_scene.instantiate()
	elif _type == "tank":
		enemy_inst = tank_scene.instantiate()
	enemy_inst.global_position = random_spawn_position.global_position + offset
	enemy_inst.connect("spawned_health_pickup", _on_spawned_health_pickup)
	enemy_inst.connect("enemy_died", _on_enemy_died)
	enemy_container.add_child(enemy_inst)

func spawn_wave():
	wave_counter += 1
	wave_time_left = wave_time
	hud.set_time_label(wave_time_left)

	var num_soldiers = int(wave_counter * 1.5 / 5) + 2
	for i in num_soldiers:
		spawn_enemy("soldier")

	var num_tanks = int(wave_counter / 5)
	for i in num_tanks:
		spawn_enemy("tank")
	
func _on_wave_timeout():
	wave_time_left -= 1
	if wave_time_left <= 0:
		spawn_wave()
		update_hud()

func enemies_left() -> int:
	return enemy_container.get_children().size()

func update_hud():
	hud.set_score_label(score)
	hud.set_wave_label(wave_counter)
	hud.set_enemies_left_label(enemies_left())
	hud.set_time_label(wave_time_left)

func _on_spawned_health_pickup(spawn_pos):
	var pickup_inst = health_pickup_scene.instantiate()
	pickup_inst.global_position = spawn_pos
	pickups_container.call_deferred("add_child", pickup_inst)

func _on_enemy_died(score_amount):
	score += score_amount
	hud.set_score_label(score)

func _on_player_died():
	wave_timer.stop()
	hud.hide()
	game_over_screen.set_score_label(score)
	game_over_screen.set_wave_label(wave_counter)
	game_over_screen.show()


func _on_player_hit(damage: float):
	var intensity = (damage / 20) * 5
	player_camera.shake(intensity, 0.3)
