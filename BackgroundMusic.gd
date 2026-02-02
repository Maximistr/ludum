extends Node

var music_player: AudioStreamPlayer

var menu_music = preload("res://music/menu music.mp3")
var game_music = preload("res://music/in game music.mp3")

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Master"

func play_menu_music():
	_play_music(menu_music)

func play_game_music():
	_play_music(game_music)

func _play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.play()
