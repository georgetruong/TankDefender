extends Unit

class_name Player

signal player_died
signal player_hit(damage: float)

var target_position = null

@onready var target_line = $TargetLine
@onready var turret = $TurretSprite
@onready var muzzle_flash = $TurretSprite/MuzzleFlashSprite
@onready var muzzle_flash_timer = $MuzzleFlashTimer
@export var muzzle_flash_delay: float = 0.2

var shell_scene = preload("res://scenes/player_tank_projectile.tscn")
@export var projectile_spawn_distance: int = 50

@export var show_movement_line: bool = false

@export var rotation_speed = 5.0

func _ready():
	super._ready()
	team = Globals.Team.PLAYER
	# if show_movement_line:
	# 	setup_target_line()

	muzzle_flash_timer.timeout.connect(_on_muzzle_flash_timeout)

func _process(delta):
	super._process(delta)
	var mouse_position = get_global_mouse_position()
	turret.look_at(mouse_position)	

func _physics_process(delta):
	if Input.is_action_pressed("attack") and can_attack:
		attack(get_global_mouse_position())
		can_attack = false
		attack_delay_timer.start(attack_delay)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	rotate(rotation_dir * rotation_speed * delta)

	var forward = transform.x * input_dir.y
	var sideways = transform.y * input_dir.x
	var movement = (forward - sideways) * move_speed
	velocity = movement
	move_and_slide()

	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)


############################################################################################################################
# Combat
#
############################################################################################################################
func _on_attack_delay_timer():
	can_attack = true

func attack(pos: Vector2):
	# TODO:
	#	- Add fire VFX
	#	- Play sound

	var shell_inst = shell_scene.instantiate()
	var direction = (pos - global_position).normalized()

	shell_inst.global_position = global_position + direction * projectile_spawn_distance
	shell_inst.linear_velocity = direction * shell_inst.speed
	shell_inst.rotation = direction.angle()
	shell_inst.damage = 50
	shell_inst.set_team_collision(team)
	shell_inst.set_collision_layer(Globals.PhysicsLayers["player_projectiles"])

	get_tree().root.add_child(shell_inst)
	show_muzzle_flash()

func show_muzzle_flash():
	muzzle_flash.show()
	muzzle_flash_timer.start(muzzle_flash_delay)
	
func _on_muzzle_flash_timeout():
	muzzle_flash.hide()

func damage(_amount: float):
	super.damage(_amount)
	player_hit.emit(_amount)

func die():
	super.die()
	can_attack = false
	player_died.emit()


############################################################################################################################
# Pickups
#
############################################################################################################################
func pickup_health(_heal_amount: float):
	if health_component:
		health_component.heal(_heal_amount)


############################################################################################################################
# Right click to move
#
############################################################################################################################
# func is_input_left_click(event):
# 	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

# func _unhandled_input(event):
# 	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
# 		target_position = get_global_mouse_position()
# 	elif is_input_left_click(event) and can_attack: 
# 		attack(get_global_mouse_position())
# 		can_attack = false
# 		attack_delay_timer.start(attack_delay)

#func _physics_process(delta):
	# if target_position:
	# 	var direction = (target_position - global_position).normalized()
	# 	if global_position.distance_to(target_position) > 5:
	# 		velocity = direction * move_speed
	# 		look_at(target_position)
	# 		move_and_slide()
	# 	else:
	# 		target_position = null
	# 		velocity = Vector2.ZERO
	# if show_movement_line:
	# 	update_line()


############################################################################################################################
# Movement Target Line
#
############################################################################################################################
# func setup_target_line():
# 	target_line.width = 5
# 	target_line.points = [Vector2.ZERO, Vector2.ZERO]

# 	var dash_texture = create_dash_texture(10, Color.GREEN)
# 	target_line.texture = dash_texture
# 	target_line.texture_mode = Line2D.LINE_TEXTURE_TILE
# 	target_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

# func create_dash_texture(dash_size: int, dash_color: Color):
# 	var image = Image.create(dash_size * 2, 1, false, Image.FORMAT_RGBA8)
# 	image.fill(Color.TRANSPARENT)
# 	for i in range(dash_size): 
# 		image.set_pixel(i, 0, dash_color)
# 	var texture = ImageTexture.create_from_image(image)
# 	return texture

# func update_line():
# 	# Coordinates are local relative to character
# 	if target_position:
# 		target_line.points[0] = Vector2.ZERO
# 		target_line.points[1] = to_local(target_position)
# 	else:
# 		target_line.points[0] = Vector2.ZERO
# 		target_line.points[1] = Vector2.ZERO
