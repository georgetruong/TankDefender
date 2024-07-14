extends Node

var mute_all = false

var music_vol_db = -5
var sfx_vol_db = -5
var old_music_vol_db = music_vol_db
var old_sfx_vol_db = sfx_vol_db

var sfx_attack = preload("res://assets/audio/impactMetal_000.ogg")
var sfx_explosion  = preload("res://assets/audio/explosion2.ogg")
var sfx_pickup = preload("res://assets/audio/upgrade4.ogg")
var sfx_player_death = preload("res://assets/audio/gameover2.ogg")

func _ready():
	pass

func get_sfx_stream(sfx_name: String):
	if sfx_name == "attack":
		return sfx_attack
	elif sfx_name == "explosion":
		return sfx_explosion
	elif sfx_name == "pickup":
		return sfx_pickup
	elif sfx_name == "player_death":
		return sfx_player_death
	else:
		return null

func play_sfx(sfx_name: String):
	var stream = get_sfx_stream(sfx_name)
	if stream == null:
		print_debug("Invalid SFX name")
		return
	
	var asp = AudioStreamPlayer.new()
	asp.volume_db = sfx_vol_db
	asp.name = "SFX"
	asp.stream = stream
	asp.pitch_scale = randf_range(0.8, 1.1)
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()

func play_music(stream):
	if stream:
		$MusicPlayer.stop()
		$MusicPlayer.volume_db = music_vol_db
		$MusicPlayer.stream = stream
		$MusicPlayer.play()
	else:
		print_debug("Invalid music file")

func toggle_mute(_flag: bool):
	mute_all = _flag
	if mute_all:
		print("MUTE")
		old_music_vol_db = music_vol_db
		old_sfx_vol_db = sfx_vol_db
		music_vol_db = -40
		sfx_vol_db = -40
	else:
		print("UNMUTE")
		music_vol_db = old_music_vol_db
		sfx_vol_db = old_sfx_vol_db
	$MusicPlayer.volume_db = music_vol_db

func change_music_volume(_value: float):
	music_vol_db = _value
	$MusicPlayer.volume_db = music_vol_db

func change_sfx_volume(_value: float):
	sfx_vol_db = _value
