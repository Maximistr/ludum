extends CharacterBody2D


const SPEED = 100
var direction = true


 

func _physics_process(delta: float) -> void:
	if direction == true:
		velocity.x = SPEED
	else:
		velocity.x = SPEED*-1


	move_and_slide()
