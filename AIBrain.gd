extends Node

var slime_scene = preload("res://slime.tscn")
var brain: NeuralNetwork
var fitness = 0.0
var slime: CharacterBody2D

func setup(nn: NeuralNetwork):
	brain = nn
	slime = slime_scene.instantiate()
	slime.is_ai = true
	slime.position = Vector2(536, 441) # Default start
	add_child(slime)

var time_since_fitness_increase = 0.0

func _physics_process(delta):
	if not is_instance_valid(slime):
		return
		
	# Update fitness based on height AND jelly hits
	var height = (get_parent().get_node("base_height").position.y - slime.position.y) / 64
	# Small reward for just being alive and slightly higher for moving
	var current_fitness = height + (slime.jelly_hits * 100) + (slime.velocity.length() * 0.01)
	
	if current_fitness > fitness:
		fitness = current_fitness
		time_since_fitness_increase = 0.0
	else:
		time_since_fitness_increase += delta
		
	# Kill if stuck or inactive for 10 seconds
	if time_since_fitness_increase > 10.0:
		slime.death()
		return
		
	# Get sensors
	var sensors = _get_sensors()
	var output = brain.predict(sensors)
	
	# Output 0: Jump
	if output[0] > 0.5:
		slime.ai_input = true
		
	# Output 1: Move Left, Output 2: Move Right
	var dir = 0.0
	if output[1] > 0.5: dir -= 1.0
	if output[2] > 0.5: dir += 1.0
	slime.ai_direction = dir

func _get_sensors() -> Array:
	var slime_pos = slime.global_position
	var nearest_jelly_dist = Vector2(0, -1000)
	var min_dist = 1000000.0
	
	# Find nearest jellyfish (prefer ones above, but look everywhere if none above)
	for jelly in get_tree().get_nodes_in_group("jellies"):
		var d = jelly.global_position - slime_pos
		var weight = 1.0
		if d.y > 0: weight = 5.0 # Penalize jellies below
		
		var weighted_dist = d.length() * weight
		if weighted_dist < min_dist:
			min_dist = weighted_dist
			nearest_jelly_dist = d
	
	var nearest_spike_dist = Vector2(0, 1000)
	min_dist = 1000000.0
	for spike in get_tree().get_nodes_in_group("spikes"):
		var d = spike.global_position - slime_pos
		if d.length() < min_dist:
			min_dist = d.length()
			nearest_spike_dist = d
			
	return [
		nearest_jelly_dist.x / 500.0,
		nearest_jelly_dist.y / 500.0,
		nearest_spike_dist.x / 200.0,
		nearest_spike_dist.y / 200.0,
		slime.velocity.y / 1000.0,
		float(slime.is_on_floor())
	]
