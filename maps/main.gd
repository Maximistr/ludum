extends Node

@onready var levels = [
	preload("res://maps/map1.tscn"),
	preload("res://maps/map2.tscn"),
	preload("res://maps/map3.tscn"),
	preload("res://maps/map4.tscn"),
	#preload("res://maps/map5.tscn"),
	preload("res://maps/map6.tscn"),
	#preload("res://maps/mapa7.tscn"),
	preload("res://maps/map8.tscn"),
	preload("res://maps/mapa_12.tscn"),
	#preload("res://maps/map_11.tscn"),
	#preload("res://maps/map9.tscn"),
	preload("res://maps/map_13.tscn")
]

var height

func _ready() -> void:
	BackgroundMusic.play_game_music()
	for jelly in get_tree().get_nodes_in_group("jellies"):
		pass # Group is already defined in scene or we can add it here
	$TextureRect/high_score.text = "HIGHSCORE\n" + "\n" + str(Vars.max_height) + " m"
	for i in 2:
		create_lvl()

func _process(delta: float) -> void:
	var target_slime = get_node_or_null("Slime")
	
	# If no player slime, try to find the highest AI slime
	if not target_slime:
		var best_y = 999999.0
		for brain in get_children():
			if brain.has_method("setup") and is_instance_valid(brain.slime):
				if brain.slime.position.y < best_y:
					best_y = brain.slime.position.y
					target_slime = brain.slime
	
	if not target_slime:
		return

	height = ceil(($base_height.position.y - target_slime.position.y) / 64)
	if height > Vars.max_height:
		Vars.max_height = height
	
	if target_slime.has_node("Label"):
		target_slime.get_node("Label").text = str(snapped(height, 1)) + " m"
		
	if target_slime.position.y <= $"lvl summon".position.y:
		for i in 2:
			create_lvl()
		$"lvl summon".position.y -= 3200

func create_lvl():
	$Level_spawner.position.y -= 1600
	randomize()
	var random_index = randi() % levels.size()
	var random_scene = levels[random_index]
	var new_level = random_scene.instantiate()
	new_level.position = $Level_spawner.position
	add_child(new_level)


func _on_esc_pressed() -> void:
	get_tree().change_scene_to_file("res://control.tscn")
