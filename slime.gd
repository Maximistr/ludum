extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var hit_val = 0


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("atk"):
		$attack.play("default")
		
		
	if Input.is_action_just_pressed("atk") and hit_val > 0:
		velocity.y = 0
		if hit_val == 2:
			velocity.y += JUMP_VELOCITY * 1.2
		else:
			velocity.y += JUMP_VELOCITY
		print(hit_val)
		hit_val = 0

	move_and_slide()


func _on_early_area_entered(area: Area2D) -> void:
	if area.name == "sus":
		hit_val = 1
func _on_crit_area_entered(area: Area2D) -> void:
	if area.name == "sus":
		hit_val = 2
func _on_late_area_entered(area: Area2D) -> void:
	if area.name == "sus":
		hit_val = 3
func _on_late_area_exited(area: Area2D) -> void:
	if area.name == "sus":
		hit_val = 0

	

func death():
	pass
