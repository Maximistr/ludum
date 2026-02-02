extends CharacterBody2D

 
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var hit_val = 0
var can_do = false
var can_atk = true

@export var is_ai = false
var ai_input = false
var ai_direction = 0.0
var jelly_hits = 0

func _ready() -> void:
	if is_ai:
		# AI slimes don't collide with each other (layer 2)
		collision_layer = 4 # put AI on layer 3
		collision_mask = 1 # only collide with world (layer 1)
	
	$Sprite.play("spawn")
	await get_tree().create_timer(1).timeout
	can_do = true
	can_atk = true

func _physics_process(delta: float) -> void:
	if not is_on_floor() and can_do == true:
		velocity += get_gravity() * delta
		$Sprite.play("jump")
	if is_on_floor() and can_do == true:
		$Sprite.play("walk")
		
	if $"atk cooldown".time_left > 0:
		can_atk = false

	var direction := 0.0
	if not is_ai:
		direction = Input.get_axis("left", "right")
	else:
		direction = ai_direction
	
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
		
	var jumping = false
	if is_ai:
		jumping = ai_input
		ai_input = false # Reset after use
	else:
		jumping = Input.is_action_just_pressed("atk")

	if jumping and can_do == true and can_atk == true:
		$"atk cooldown".start()
		$attack.play("default")
		
	if $early.has_overlapping_areas() == true:
		hit_val = 1
	if  $crit.has_overlapping_areas() == true:
		hit_val = 2
	if $late.has_overlapping_areas() == true:
		hit_val = 3
	if $early.has_overlapping_areas() == false and $crit.has_overlapping_areas() == false and $late.has_overlapping_areas() == false:
		hit_val = 0
		
		
	if jumping and hit_val > 0 and not is_on_floor() and can_do == true and can_atk == true:
		kill()
		jelly_hits += 1 # Track hits for AI reward
		velocity.y = 0
		$"atk cooldown".stop()
		if hit_val == 2:
			velocity.y += JUMP_VELOCITY * 1.2
		else:
			velocity.y += JUMP_VELOCITY
		hit_val = 0

	if jumping and is_on_floor() and can_do == true:
		velocity.y = JUMP_VELOCITY + 50
	
	move_and_slide()

func death():
	if is_ai:
		queue_free() # AI trainer will handle respawns
		return
	can_do = false
	$Sprite.play("death")
	await get_tree().create_timer(0.8).timeout
	if get_tree():
		get_tree().reload_current_scene()
	else:
		pass


func _on_jelly_area_entered(area: Area2D) -> void:
	if area.name == "sus":
		var e = area.get_parent()
		e.death()
	if area.name == "start_jump":
		velocity.y -= 600
	
func kill():
	$jelly/col_kill.disabled = false
	await get_tree().create_timer(0.05).timeout
	$jelly/col_kill.disabled = true


func _on_atk_cooldown_timeout() -> void:
	can_atk = true
