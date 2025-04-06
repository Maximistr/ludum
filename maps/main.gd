extends Node

var levels
var height

func _ready() -> void:
	$TextureRect/high_score.text = "HIGHSCORE\n" + "\n" + str(Vars.max_height) + " m"
	
func _process(delta: float) -> void:
	height = ceil(( $base_height.position.y - $Slime.position.y ) / 64)
	if height > Vars.max_height:
		Vars.max_height = height
	$Slime/Label.text = str(snapped(height,1)) + " m"
	
