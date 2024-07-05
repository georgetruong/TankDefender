extends RigidBody2D
class_name Projectile

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
	return area.get_parent().team != team

func _on_hitbox_component_area_entered(area):
	linear_velocity = Vector2.ZERO
	if area is HitboxComponent and is_collision_with_enemy(area):
		area.damage(damage)
		queue_free()

func _on_body_entered(body:Node):
	# NOTE: Handles general object collisions. Damage is handled by HitboxComponent.
	if (body is TileMap) or (body is Unit) or (body is Projectile):
		linear_velocity = Vector2.ZERO
		queue_free()

func set_team_collision(team_type: Globals.Team):
	team = team_type
	if team_type == Globals.Team.PLAYER:
		set_collision_layer(Globals.PhysicsLayers["player_projectiles"])
	elif team_type == Globals.Team.ENEMY:
		set_collision_layer(Globals.PhysicsLayers["enemy_projectiles"])
	else:
		print_debug("TEAM TYPE NOT IMPLEMENTED")

	set_collision_mask_value(Globals.PhysicsLayers["world"], true)
	set_collision_mask_value(Globals.PhysicsLayers["player_projectiles"], false)
	set_collision_mask_value(Globals.PhysicsLayers["enemy_projectiles"], false)
	
	var mask_flag = team_type == Globals.Team.PLAYER
	set_collision_mask_value(Globals.PhysicsLayers["player_units"], !mask_flag)
	set_collision_mask_value(Globals.PhysicsLayers["enemy_units"], mask_flag)
