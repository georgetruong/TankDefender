extends Control
class_name MenuScreen

signal close_menu_screen

@onready var music_vol_slider = $MusicVolumeSlider
@onready var sfx_vol_slider = $SFXVolumeSlider

func _ready():
	music_vol_slider.value = AudioManager.music_vol_db
	sfx_vol_slider.value = AudioManager.sfx_vol_db

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_base.tscn")

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_resume_button_pressed():
	close_menu_screen.emit()

func _on_music_volume_slider_value_changed(value:float):
	AudioManager.change_music_volume(value)

func _on_sfx_volume_slider_value_changed(value:float):
	AudioManager.change_sfx_volume(value)

func _on_mute_button_toggled(toggled_on:bool):
	AudioManager.toggle_mute(toggled_on)
