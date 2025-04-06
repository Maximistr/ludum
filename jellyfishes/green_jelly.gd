extends CharacterBody2D


const SPEED = 69
var direction = true
var e = true

 

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
