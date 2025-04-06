extends CharacterBody2D
var allow_fade_out := true



func _ready() -> void:
	$Sprite/Timer.start()
	_fade_loop()


func _process(delta: float) -> void:
	#$Sprite.modulate.a = $Sprite/Timer.time_left
	if allow_fade_out:
		$Sprite.modulate.a = $Sprite/Timer.time_left / $Sprite/Timer.wait_time

func fade_in():
	$Sprite/Timer.start()
	await $Sprite/Timer.timeout
	while $Sprite/Timer.time_left > 0:
		$Sprite.modulate.a = 1.0 - ($Sprite/Timer.time_left / $Sprite/Timer.wait_time)
		await get_tree().process_frame
	$Sprite.modulate.a = 1.0
#func _on_Timer_timeout():
	#$Sprite/Timer.stop()
	#allow_fade_out = false
	#await fade_in()
func _fade_loop():
	while true:
		allow_fade_out = true
		$Sprite/Timer.start()
		await $Sprite/Timer.timeout
		allow_fade_out = false
		await fade_in()
		await get_tree().create_timer(1.0).timeout  # wait 1 second before repeating
