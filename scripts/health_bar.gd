extends Control

@onready var progress_bar = $ProgressBar
@onready var timer = $Timer

var hide_delay = 3.0

func _ready():
	#hide()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_hideout)
	setup_progress_bar()

func setup_progress_bar():
	var background_style = StyleBoxFlat.new()
	background_style.bg_color = Color.DARK_GRAY
	background_style.corner_radius_top_left = 5
	background_style.corner_radius_top_right = 5
	background_style.corner_radius_bottom_left = 5
	background_style.corner_radius_bottom_right = 5

	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color.RED
	fill_style.corner_radius_top_left = 5
	fill_style.corner_radius_top_right = 5
	fill_style.corner_radius_bottom_left = 5
	fill_style.corner_radius_bottom_right = 5

	progress_bar.add_theme_stylebox_override("background", background_style)
	progress_bar.add_theme_stylebox_override("fill", fill_style)

func update_health(current_health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = current_health
	show()
	timer.start(hide_delay)


func _on_timer_hideout():
	#hide()
	pass
