extends Unit
class_name EnemyUnit

signal spawned_health_pickup(spawn_pos)

@onready var turret_sprite = $TankTurretSprite

var player = null
var shell_scene = preload("res://scenes/enemy_tank_projectile.tscn")

@export var attack_range: float = 500.0

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var nav_timer = $NavTimer

@export_range(0, 100) var spawn_pickup_chance = 20

func _ready():
	super._ready()
	team = Globals.Team.ENEMY
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if !player:
		return

	turret_sprite.look_at(player.global_position)
	if has_line_of_sight() and is_in_attack_range() and can_attack:
		attack(player.global_position)
		can_attack = false
		attack_delay_timer.start(attack_delay)
	else:
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * move_speed
		move_and_slide()
		look_at(next_position)

func is_in_attack_range():
	# TODO: Refactor into Unit
	return global_position.distance_to(player.global_position) <= attack_range

func has_line_of_sight() -> bool:
	# TODO: Refactor into Unit
	if !player:
		return false

	attack_raycast.global_position = global_position
	attack_raycast.target_position = to_local(player.global_position)
	attack_raycast.force_raycast_update()

	if attack_raycast.is_colliding():
		return attack_raycast.get_collider() == player
	else:
		return true

func attack(pos: Vector2):	
	# TODO: Refactor into Unit
	var shell_inst = shell_scene.instantiate()
	var direction = (pos - global_position).normalized()

	shell_inst.global_position = global_position + direction * 100
	shell_inst.linear_velocity = direction * shell_inst.speed
	shell_inst.rotation = direction.angle()
	shell_inst.damage = 10

	shell_inst.set_team_collision(team)
	get_tree().root.add_child(shell_inst)

func die():
	super.die()
	var n = randf_range(0, 100)
	if n <= spawn_pickup_chance:
		spawned_health_pickup.emit(global_position)

func _on_attack_delay_timer():
	can_attack = true

func make_path() -> void:
	if player != null:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = global_position

func _on_nav_timer_timeout():
	make_path()
