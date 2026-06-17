extends Control
@onready var settings: Panel = $settings
@onready var main_menu: Control = $main_menu
@onready var fullscreen_btn: Button = $settings/TextureRect5/fullscreen

func _ready():
	BackgroundMusic.play_menu_music()
	main_menu.visible = true
	settings.visible = false
	_update_fullscreen_label()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://maps/main.tscn")


func _on_settings_pressed() -> void:
	main_menu.visible = false
	settings.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_back_pressed() -> void:
	main_menu.visible = true
	settings.visible = false


func _on_fullscreen_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_update_fullscreen_label()


func _update_fullscreen_label() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_btn.text = "windowed"
	else:
		fullscreen_btn.text = "fullscreen"
