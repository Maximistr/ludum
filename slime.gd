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
		
	if $early.has_overlapping_areas() == true:
		hit_val = 1
	if  $crit.has_overlapping_areas() == true:
		hit_val = 2
	if $late.has_overlapping_areas() == true:
		hit_val = 3
	if $early.has_overlapping_areas() == false and $crit.has_overlapping_areas() == false and $late.has_overlapping_areas() == false:
		hit_val = 0
		
		
	if Input.is_action_just_pressed("atk") and hit_val > 0 and not is_on_floor():
		velocity.y = 0
		kill()
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

func death():
	pass

func _on_jelly_area_entered(area: Area2D) -> void:
	var e = area#.get_parent()
	e.death()

	
func kill():
	$jelly/col_kill.disabled = false
	await get_tree().create_timer(0.1).timeout
	$jelly/col_kill.disabled = true
