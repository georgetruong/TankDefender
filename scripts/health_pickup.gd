extends Area2D

@export var heal_amount: float = 25.0
@export var destroy_delay: float = 15.0

var timer

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start(destroy_delay)

func _on_body_entered(body): 
	if body is Player:
		body.pickup_health(heal_amount)
		queue_free()

func _on_timer_timeout():
	timer.stop()
	queue_free()