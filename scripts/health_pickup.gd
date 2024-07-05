extends Area2D

@export var heal_amount: float = 25.0

func _on_body_entered(body): 
	if body is Player:
		body.pickup_health(heal_amount)
		queue_free()