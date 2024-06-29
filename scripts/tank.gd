extends CharacterBody2D

@export var move_speed = 200

var target_position = null

@onready var target_line = $TargetLine

func _ready():
	target_line.default_color = Color.GREEN
	target_line.width = 1
	target_line.points = [Vector2.ZERO, Vector2.ZERO]

func _process(delta):
	if !target_position:
		var mouse_position = get_global_mouse_position()
		look_at(mouse_position)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		target_position = get_global_mouse_position()

func _physics_process(delta):
	if target_position:
		var direction = (target_position - global_position).normalized()
		if global_position.distance_to(target_position) > 5:
			velocity = direction * move_speed
			look_at(target_position)
			move_and_slide()
		else:
			target_position = null
			velocity = Vector2.ZERO

	update_line()

func update_line():
	# Coordinates local relative to character
	if target_position:
		target_line.points[0] = Vector2.ZERO 
		target_line.points[1] = to_local(target_position)
	else:
		target_line.points[0] = Vector2.ZERO 
		target_line.points[1] = Vector2.ZERO