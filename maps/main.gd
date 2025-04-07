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
	$TextureRect/high_score.text = "HIGHSCORE\n" + "\n" + str(Vars.max_height) + " m"
	for i in 2:
		create_lvl()

func _process(delta: float) -> void:
	height = ceil(($base_height.position.y - $Slime.position.y) / 64)
	if height > Vars.max_height:
		Vars.max_height = height
	$Slime/Label.text = str(snapped(height, 1)) + " m"
	if $Slime.position.y <= $"lvl summon".position.y:
		for i in 2:
			create_lvl()
		$"lvl summon".position.y -= 3200
		
	print($Slime/Camera2D.global_position)

func create_lvl():
	$Level_spawner.position.y -= 1600
	randomize()
	var random_index = randi() % levels.size()
	var random_scene = levels[random_index]
	var new_level = random_scene.instantiate()
	new_level.position = $Level_spawner.position
	add_child(new_level)
