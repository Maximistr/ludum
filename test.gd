extends Node


func _process(delta: float) -> void:
	if $Slime.position.y > get_window().size.y:
		get_tree().reload_current_scene()
