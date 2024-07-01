extends CharacterBody2D

class_name Unit

var team = Globals.Team.ENEMY

var unit_type = Globals.UnitType.GROUND

@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent

@export var move_speed = 200

@export var sprite_size: Vector2 = Vector2(128, 128)

@onready var death_sprite = $DeathSprite
var show_death_sprite_delay = 0.3

func _ready():
	death_sprite.hide()
	pass

func _process(delta):
	pass

func attack():
	pass

func die():
	if health_component:
		health_component.hide_health_bar()

	var timer = Timer.new()
	get_tree().root.add_child(timer)
	timer.start(show_death_sprite_delay)
	death_sprite.show()

	await timer.timeout
	timer.queue_free()
	queue_free()
