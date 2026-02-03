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
	
	# Reward for hitting the start target if no jellies hit yet
	var start_reward = 0.0
	if slime.jelly_hits == 0:
		var start_targets = get_tree().get_nodes_in_group("start_targets")
		if not start_targets.is_empty():
			var dist_vec = start_targets[0].global_position - slime.global_position
			var dist_to_start = dist_vec.length()
			# Proximity reward
			start_reward = max(0, (600.0 - dist_to_start) / 100.0)
			# "Hint" reward: Gain fitness for moving right (towards the target)
			if slime.velocity.x > 0:
				start_reward += 2.0
			# "Hint" reward: If falling and near target, being in the air is good
			if slime.velocity.y > 0 and dist_to_start < 200:
				start_reward += 5.0

	var current_fitness = height + (slime.jelly_hits * 100) + (slime.perfect_target_hits * 500) + (slime.velocity.length() * 0.01) + start_reward
	
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
		# Extra reward for attacking at the perfect time (start of fall near target)
		if slime.jelly_hits == 0 and slime.velocity.y > 0 and slime.velocity.y < 50:
			var start_targets = get_tree().get_nodes_in_group("start_targets")
			if not start_targets.is_empty():
				if (start_targets[0].global_position - slime.global_position).length() < 100:
					fitness += 50.0 # Instant reward for good timing
		
	# Output 1: Move Left, Output 2: Move Right
	var dir = 0.0
	if output[1] > 0.5: dir -= 1.0
	if output[2] > 0.5: dir += 1.0
	slime.ai_direction = dir

func _get_sensors() -> Array:
	var slime_pos = slime.global_position
	var world = get_parent()
	
	# Find nearest start target (initial boost) in THIS world
	var nearest_start_dist = Vector2(0, -1000)
	var min_dist = 1000000.0
	for target in get_tree().get_nodes_in_group("start_targets"):
		if world.is_ancestor_of(target):
			var d = target.global_position - slime_pos
			if d.length() < min_dist:
				min_dist = d.length()
				nearest_start_dist = d

	var nearest_jelly_dist = Vector2(0, -1000)
	min_dist = 1000000.0
	
	# Find nearest jellyfish in THIS world
	for jelly in get_tree().get_nodes_in_group("jellies"):
		if world.is_ancestor_of(jelly):
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
		if world.is_ancestor_of(spike):
			var d = spike.global_position - slime_pos
			if d.length() < min_dist:
				min_dist = d.length()
				nearest_spike_dist = d
			
	return [
		nearest_start_dist.x / 500.0,
		nearest_start_dist.y / 500.0,
		nearest_jelly_dist.x / 500.0,
		nearest_jelly_dist.y / 500.0,
		nearest_spike_dist.x / 200.0,
		nearest_spike_dist.y / 200.0,
		slime.velocity.x / 300.0,
		slime.velocity.y / 1000.0,
		float(slime.velocity.y > 0), # Binary falling sensor
		float(slime.is_on_floor())
	]
