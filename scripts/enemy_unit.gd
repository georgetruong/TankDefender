extends Unit

class_name EnemyUnit

@onready var turret_sprite = $TankTurretSprite

var player = null
var shell_scene = preload("res://scenes/enemy_tank_projectile.tscn")

@export var attack_range: float = 500.0

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var nav_timer = $NavTimer

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
	return global_position.distance_to(player.global_position) <= attack_range

func has_line_of_sight() -> bool:
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
	var shell_inst = shell_scene.instantiate()
	var direction = (pos - global_position).normalized()

	shell_inst.global_position = global_position
	shell_inst.linear_velocity = direction * 500
	shell_inst.rotation = direction.angle()

	shell_inst.team = team
	get_tree().root.add_child(shell_inst)

func _on_attack_delay_timer():
	can_attack = true

func make_path() -> void:
	nav_agent.target_position = player.global_position

func _on_nav_timer_timeout():
	make_path()
