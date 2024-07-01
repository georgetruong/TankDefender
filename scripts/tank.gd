extends Unit

class_name Tank

var target_position = null

@onready var target_line = $TargetLine
@onready var turret = $TankTurretSprite

var shell_scene = preload("res://scenes/projectile.tscn")

func _ready():
	super._ready()
	setup_target_line()

func _process(delta):
	super._process(delta)
	var mouse_position = get_global_mouse_position()
	turret.look_at(mouse_position)	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		target_position = get_global_mouse_position()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attack()

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
func attack():
	# TODO:
	#	- Fire from turret muzzle
	#	- Add fire VFX
	#	- Play sound
	var mouse_pos = get_global_mouse_position()
	var shell_inst = shell_scene.instantiate()
	var direction = (mouse_pos - global_position).normalized()

	shell_inst.global_position = global_position
	shell_inst.linear_velocity = direction * 500
	shell_inst.rotation = direction.angle()

	get_tree().root.add_child(shell_inst)
