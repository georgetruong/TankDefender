extends RigidBody2D

@onready var hitbox_component = $HitboxComponent

@export var speed = 500
@export var damage = 50

var team: Globals.Team = Globals.Team.PLAYER

func _ready():
	gravity_scale = 0
	lock_rotation = true

	await get_tree().create_timer(2.0).timeout
	queue_free()

func is_collision_with_enemy(area):
	return area.get_parent().team != team

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent and is_collision_with_enemy(area):
		area.damage(damage)
		queue_free()
