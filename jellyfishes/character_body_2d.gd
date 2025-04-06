extends CharacterBody2D

func death():
	$hit_area.monitorable = false 
	$body_area.monitoring = false 
	$Sprite.play("death")
	if $Sprite.animation_finished:
		queue_free()

func _on_body_area_body_entered(body: Node2D) -> void:
	body.death
