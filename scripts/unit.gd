extends CharacterBody2D

class_name Unit

@export var current_health : int = 100
@export var max_health : int = 100

@export var move_speed = 200

@export var sprite_size: Vector2 = Vector2(128, 128)

@onready var health_bar = $HealthBar

func _ready():
	pass	

func _process(delta):
	# TODO: BUG - Health bar shouldn't rotate with the character. Put it into level canvas layer.
	health_bar.update_health(current_health, max_health)

func take_damage(amount):
	current_health -= amount
	current_health = max(current_health, 0)
	health_bar.update_health(current_health)
