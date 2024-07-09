extends Control
class_name MenuScreen

signal close_menu_screen

func _ready():
	#$ResumeButton.pressed.connect(_on_resume_button_pressed)
	pass

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_base.tscn")

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_resume_button_pressed():
	close_menu_screen.emit()
