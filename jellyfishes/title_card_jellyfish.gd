extends CharacterBody2D
var allow_fade_out := true
var g = true


func _process(delta: float) -> void:
	#print($Sprite.modulate.a)
	#$Spritmodulate.a = $Sprite/Timer.time_left
	if $Sprite.modulate.a > 0:
		$Hit_area/hit.disabled = false
		$sus/body.disabled = false
	if $Sprite.modulate.a >= 1:
		g = true
	elif $Sprite.modulate.a <= 0:
		$Hit_area/hit.disabled = true
		$sus/body.disabled = true
		await get_tree().create_timer(1).timeout
		g = false
	if g == true:
		$Sprite.modulate.a -= 0.5 * delta
	if g == false:
		$Sprite.modulate.a += 0.5 * delta
	
