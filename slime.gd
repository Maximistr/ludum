extends CharacterBody2D

 
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var hit_val = 0
var upg = []
var can_do = false

func _ready() -> void:
	$Sprite.play("spawn")
	await get_tree().create_timer(1).timeout
	can_do = true

func _physics_process(delta: float) -> void:
	if not is_on_floor() and can_do == true:
		velocity += get_gravity() * delta
		$Sprite.play("jump")
	if is_on_floor() and can_do == true:
		$Sprite.play("walk")

	var direction := Input.get_axis("left", "right")
	if direction and can_do == true:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction == -1:
		$attack.flip_v = true
		$Sprite.flip_h = false
	if direction == 1:
		$attack.flip_v = false
		$Sprite.flip_h = true
		
	if Input.is_action_just_pressed("atk") and can_do == true:
		$attack.play("default")
		
	if $early.has_overlapping_areas() == true:
		hit_val = 1
	if  $crit.has_overlapping_areas() == true:
		hit_val = 2
	if $late.has_overlapping_areas() == true:
		hit_val = 3
	if $early.has_overlapping_areas() == false and $crit.has_overlapping_areas() == false and $late.has_overlapping_areas() == false:
		hit_val = 0
		
		
	if Input.is_action_just_pressed("atk") and hit_val > 0 and not is_on_floor() and can_do == true:
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

	if Input.is_action_just_pressed("atk") and is_on_floor() and can_do == true:
		velocity.y = JUMP_VELOCITY + 50
	
	move_and_slide()

func death():
	can_do = false
	$Sprite.play("death")
	get_tree().reload_current_scene()

func _on_jelly_area_entered(area: Area2D) -> void:
	var e = area.get_parent()
	e.death()

	
func kill():
	$jelly/col_kill.disabled = false
	await get_tree().create_timer(0.05).timeout
	$jelly/col_kill.disabled = true
	
	
