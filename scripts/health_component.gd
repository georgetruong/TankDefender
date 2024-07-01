extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : int = 100
var health : float 

@onready var health_bar = $HealthBar

func _ready():
	health = MAX_HEALTH

func _process(delta):
	health_bar.update_health(health, MAX_HEALTH)

func hide_health_bar():
	health_bar.hide()

#func damage(attack: Attack): # TODO: Pull out attacks to its own class
func damage(amount: float):
	health -= amount
	health = max(health, 0)
	if health <= 0:
		die()
	else:
		health_bar.update_health(health, MAX_HEALTH)

func die():
	# TODO: Emit death signal to parent
	get_parent().queue_free()