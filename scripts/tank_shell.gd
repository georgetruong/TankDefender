extends RigidBody2D

@export var speed = 500

func _ready():
	gravity_scale = 0
	lock_rotation = true

	await get_tree().create_timer(2.0).timeout
	queue_free()

func _on_body_entered(body):
	if !(body is Tank):
		print("HIT!")
		queue_free()