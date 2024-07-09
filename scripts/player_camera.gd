extends Camera2D

var shake_amount = 0
var default_offset = offset

func _ready():
	set_process(false)

func _process(delta):
	offset = Vector2(randf_range(-1,1) * shake_amount, randf_range(-1,1) * shake_amount)

func shake(amount, duration):
	shake_amount = amount
	set_process(true)
	get_tree().create_timer(duration).timeout.connect(stop_shake)

func stop_shake():
	set_process(false)
	offset = default_offset