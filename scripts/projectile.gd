extends RigidBody2D

@export var speed = 500
@export var damage = 50

@onready var area = $Area2D

func _ready():
	gravity_scale = 0
	lock_rotation = true

	area.body_entered.connect(_on_body_entered)

	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_body_entered(body):
	# TODO: Add explosion VFX and sound on collision
	# TODO: Direct hit damage and also splash damage
	if body is EnemyUnit:
		body.take_damage(damage)
	queue_free()
