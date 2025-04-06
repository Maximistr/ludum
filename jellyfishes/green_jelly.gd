extends CharacterBody2D


const SPEED = 69
var direction = true
var e = true

func death():
	$sus.monitorable = false 
	$body_area.monitoring = false 
	$Sprite.play("death")
	await get_tree().create_timer(0.8).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if direction == true:
		velocity.x = SPEED
	else:
		velocity.x = SPEED*-1
	if is_on_wall() and e == true:
		direction = !direction
		e = false
		await get_tree().create_timer(0.5).timeout
		e = true

	move_and_slide()


func _on_body_area_body_entered(body: Node2D) -> void:
	body.death()
