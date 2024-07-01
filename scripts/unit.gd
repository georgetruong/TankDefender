extends CharacterBody2D

class_name Unit

@export var current_health : int = 100
@export var max_health : int = 100

@export var move_speed = 200

@export var sprite_size: Vector2 = Vector2(128, 128)

@onready var health_bar = $HealthBar

@onready var death_sprite = $DeathSprite
var show_death_sprite_delay = 0.3

var unit_type = "enemy"

func _ready():
	death_sprite.hide()
	pass

func _process(delta):
	# TODO: BUG - Health bar shouldn't rotate with the character. Put it into level canvas layer.
	health_bar.update_health(current_health, max_health)

func attack():
	pass

func take_damage(amount):
	current_health -= amount
	current_health = max(current_health, 0)
	print(current_health)
	if current_health <= 0:
		die()
	else:
		health_bar.update_health(current_health, max_health)

func die():
	health_bar.hide()

	var timer = Timer.new()
	get_tree().root.add_child(timer)
	timer.start(show_death_sprite_delay)
	death_sprite.show()

	await timer.timeout
	timer.queue_free()
	queue_free()
