extends Node2D

func _on_level_01_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")

func _on_level_02_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_02.tscn")

func _on_level_03_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_03.tscn")
