extends CharacterBody2D

class_name Unit

var team = Globals.Team.ENEMY

var unit_type = Globals.UnitType.GROUND

@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent

@export var move_speed = 200
@export var sprite_size: Vector2 = Vector2(128, 128)

@onready var attack_delay_timer = $AttackDelayTimer
@onready var attack_raycast = $AttackRayCast
@export var attack_delay: float = 1.0
var can_attack: bool = true

@onready var death_sprite = $DeathSprite
var show_death_sprite_delay = 0.3

func _ready():
	health_component.hide_health_bar()
	death_sprite.hide()
	attack_delay_timer.one_shot = true
	attack_delay_timer.timeout.connect(_on_attack_delay_timer)

func _process(delta):
	pass

func attack(pos: Vector2):
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

func _on_attack_delay_timer():
	pass

func _on_nav_timer_timeout():
	pass # Replace with function body.
