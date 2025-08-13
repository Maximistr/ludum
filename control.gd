extends Control
@onready var settings: Panel = $settings
@onready var main_menu: Control = $main_menu

func _ready():
	main_menu.visible = true
	settings.visible = false

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
