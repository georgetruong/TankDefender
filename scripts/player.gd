extends Unit

class_name Player

signal player_died
signal player_hit(damage: float)

var target_position = null

@onready var target_line = $TargetLine
@onready var turret = $TurretSprite

var shell_scene = preload("res://scenes/player_tank_projectile.tscn")

@export var show_movement_line: bool = false

func _ready():
	super._ready()
	team = Globals.Team.PLAYER
	if show_movement_line:
		setup_target_line()

func _process(delta):
	super._process(delta)
	var mouse_position = get_global_mouse_position()
	turret.look_at(mouse_position)	

func is_input_left_click(event):
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		target_position = get_global_mouse_position()
	elif is_input_left_click(event) and can_attack: 
		# TODO: hold down button to continuously attack
		attack(get_global_mouse_position())
		can_attack = false
		attack_delay_timer.start(attack_delay)

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
	if show_movement_line:
		update_line()

func die():
	super.die()
	can_attack = false
	player_died.emit()

############################################################################################################################
# Movement Target Line
#
############################################################################################################################
func setup_target_line():
	target_line.width = 5
	target_line.points = [Vector2.ZERO, Vector2.ZERO]

	var dash_texture = create_dash_texture(10, Color.GREEN)
	target_line.texture = dash_texture
	target_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	target_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func create_dash_texture(dash_size: int, dash_color: Color):
	var image = Image.create(dash_size * 2, 1, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	for i in range(dash_size): 
		image.set_pixel(i, 0, dash_color)
	var texture = ImageTexture.create_from_image(image)
	return texture

func update_line():
	# Coordinates are local relative to character
	if target_position:
		target_line.points[0] = Vector2.ZERO
		target_line.points[1] = to_local(target_position)
	else:
		target_line.points[0] = Vector2.ZERO
		target_line.points[1] = Vector2.ZERO


############################################################################################################################
# Attack
#
############################################################################################################################
func _on_attack_delay_timer():
	can_attack = true

func attack(pos: Vector2):
	# TODO:
	#	- Fire from turret muzzle
	#	- Add fire VFX
	#	- Play sound

	# TODO: Refactor into Unit
	var shell_inst = shell_scene.instantiate()
	var direction = (pos - global_position).normalized()

	shell_inst.global_position = global_position + direction * 100
	shell_inst.linear_velocity = direction * shell_inst.speed
	shell_inst.rotation = direction.angle()
	shell_inst.damage = 50
	shell_inst.set_team_collision(team)
	shell_inst.set_collision_layer(Globals.PhysicsLayers["player_projectiles"])

	get_tree().root.add_child(shell_inst)

func damage(_amount: float):
	super.damage(_amount)
	player_hit.emit(_amount)

############################################################################################################################
# Pickups
#
############################################################################################################################
func pickup_health(_heal_amount: float):
	if health_component:
		health_component.heal(_heal_amount)