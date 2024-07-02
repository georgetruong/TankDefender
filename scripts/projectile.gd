extends RigidBody2D

@onready var hitbox_component = $HitboxComponent

@export var speed = 1500
@export var damage = 50

var team: Globals.Team = Globals.Team.PLAYER

func _ready():
	gravity_scale = 0
	lock_rotation = true

	contact_monitor = true
	max_contacts_reported = 1

	await get_tree().create_timer(5.0).timeout
	queue_free()

func is_collision_with_enemy(area):
	# TODO: Fix using collision layers?
	return area.get_parent().team != team

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent and is_collision_with_enemy(area):
		area.damage(damage)
		queue_free()

func _on_body_entered(body:Node):
	if body is TileMap:
		queue_free()

func set_team_collision(team_type: Globals.Team):
	team = team_type
	if team_type == Globals.Team.PLAYER:
		set_collision_layer(Globals.PhysicsLayers["player_projectiles"])
	elif team_type == Globals.Team.ENEMY:
		set_collision_layer(Globals.PhysicsLayers["enemy_projectiles"])
	else:
		print_debug("TEAM TYPE NOT IMPLEMENTED")

	var mask_flag = team_type == Globals.Team.PLAYER
	set_collision_mask_value(Globals.PhysicsLayers["player_units"], mask_flag)
	set_collision_mask_value(Globals.PhysicsLayers["player_projectiles"], mask_flag)
	set_collision_mask_value(Globals.PhysicsLayers["enemy_units"], !mask_flag)
	set_collision_mask_value(Globals.PhysicsLayers["enemy_projectiles"], !mask_flag)

	set_collision_mask_value(Globals.PhysicsLayers["world"], true)

	print("%b" % collision_mask)
	