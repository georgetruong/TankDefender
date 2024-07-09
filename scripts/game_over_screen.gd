extends Control
class_name GameOveScreen

@onready var restart_button = $RestartButton

func set_wave_label(_wave: int):
	$WaveLabel.text = "WAVE: " + str(_wave)

func set_score_label(_score: int):
	$ScoreLabel.text = "SCORE: " + str(_score)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_base.tscn")