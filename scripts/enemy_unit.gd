extends Unit

class_name EnemyUnit

@onready var turret_sprite = $TankTurretSprite

var player = null
var shell_scene = preload("res://scenes/enemy_tank_projectile.tscn")

@export var attack_range: float = 500.0

func _ready():
	super._ready()
	team = Globals.Team.ENEMY

func _process(delta):
	player = get_tree().get_first_node_in_group("player")
	if player:
		turret_sprite.look_at(player.global_position)
		if is_in_attack_range() and can_attack:
			attack(player.global_position)
			can_attack = false
			attack_delay_timer.start(attack_delay)
		elif !is_in_attack_range():
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * move_speed
			look_at(player.position)
			move_and_slide()

func is_in_attack_range():
	return global_position.distance_to(player.global_position) <= attack_range

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