extends Control
class_name MenuScreen

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_base.tscn")

func _on_quit_button_pressed():
	get_tree().quit()