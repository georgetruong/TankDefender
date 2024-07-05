extends Control
class_name HUD

func set_time_label(_time: int):
	$TimeLabel.text = "NEXT WAVE: " + str(_time) 

func set_wave_label(_wave: int):
	$WaveLabel.text = "WAVE: " + str(_wave)

func set_enemies_left_label(_enemies_left: int):
	$EnemiesLeftLabel.text = "ENEMIES LEFT: " + str(_enemies_left)
