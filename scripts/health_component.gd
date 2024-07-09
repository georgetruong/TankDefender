extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : float = 100.0
var health : float 

@onready var health_bar = $HealthBar

@export var offset = Vector2(0, -10)

func _ready():
	top_level = true

	health = MAX_HEALTH
	hide_health_bar()

func _process(delta):
	global_position = get_parent().global_position + offset
	global_rotation = 0

	health_bar.update_health(health, MAX_HEALTH)
	if health > 0 and health <  MAX_HEALTH:
		show_health_bar()
	else:
		hide_health_bar()

func show_health_bar():
	health_bar.show()

func hide_health_bar():
	health_bar.hide()

#func damage(attack: Attack): # TODO: Pull out attacks to its own class
func damage(amount: float):
	health -= amount
	health = max(health, 0)
	if health <= 0:
		hide_health_bar()
		die()
	else:
		health_bar.update_health(health, MAX_HEALTH)
	
func heal(amount: float):
	health += amount
	health = min(MAX_HEALTH, health)
	health_bar.update_health(health, MAX_HEALTH)

func die():
	hide_health_bar()
	get_parent().die()
