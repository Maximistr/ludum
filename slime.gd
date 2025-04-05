extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var hit_val = 0
var upg = []

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		$Sprite.play("jump")
	if is_on_floor():
		$Sprite.play("walk")

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("atk"):
		$attack.play("default")
		
		
	if Input.is_action_just_pressed("atk") and hit_val > 0 and not is_on_floor():
		velocity.y = 0
		$"jelly/na židy".disabled = false
		if hit_val == 2:
			velocity.y += JUMP_VELOCITY * 1.2
		else:
			velocity.y += JUMP_VELOCITY
		print(hit_val)
		hit_val = 0
	if Input.is_action_just_pressed("1"):
		upg[5] = 1

	if Input.is_action_just_pressed("atk") and is_on_floor():
		velocity.y = JUMP_VELOCITY + 50
	
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

func _on_jelly_area_entered(area: Area2D) -> void:
	var e = area.get_parent()
	e.death()
	await get_tree().create_timer(0.1).timeout
	$"jelly/na židy".disabled = true
