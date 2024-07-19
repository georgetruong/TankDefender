extends Node2D

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits_screen.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
