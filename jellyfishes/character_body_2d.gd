extends CharacterBody2D

func death():
	$sus.monitorable = false 
	$body_area.monitoring = false 
	$Sprite.play("death")
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _on_body_area_body_entered(body: Node2D) -> void:
	body.death()
