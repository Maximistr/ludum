extends Node2D

var population_size = 50
var generation = 1
var aibrain_script = preload("res://AIBrain.gd")
var game_scene = preload("res://maps/main.tscn")

var current_brains = []
var best_networks = []

func _ready():
	_spawn_generation()

func _spawn_generation():
	# Clear old game instances if any
	for child in get_children():
		if child is Node2D:
			child.queue_free()
	
	# Instantiate a single game world for all slimes to compete in
	var game_instance = game_scene.instantiate()
	# Remove the default player slime from the game instance
	var player_slime = game_instance.get_node_or_null("Slime")
	if player_slime:
		player_slime.queue_free()
	
	# Hide player UI
	var label = game_instance.get_node_or_null("Label")
	if label: label.visible = false
	var canvas = game_instance.get_node_or_null("CanvasLayer")
	if canvas: canvas.visible = false
	
	add_child(game_instance)
	
	$CanvasLayer/Label.text = "Generation: " + str(generation)
	current_brains.clear()
	
	for i in range(population_size):
		var nn: NeuralNetwork
		if best_networks.is_empty():
			nn = NeuralNetwork.new([6, 16, 8, 3])
		else:
			if i < 3: # Elitism: keep best 3
				nn = best_networks[i].duplicate_network()
			else:
				var parent_nn = best_networks[randi() % best_networks.size()]
				nn = parent_nn.duplicate_network()
				nn.mutate(0.2)
		
		var brain_node = Node.new()
		brain_node.set_script(aibrain_script)
		game_instance.add_child(brain_node)
		brain_node.setup(nn)
		current_brains.append(brain_node)

func _physics_process(_delta):
	var all_dead = true
	for b in current_brains:
		if is_instance_valid(b.slime):
			all_dead = false
			break
	
	if all_dead and not current_brains.is_empty():
		_process_evolution()
		_spawn_generation()

func _process_evolution():
	current_brains.sort_custom(func(a, b): return a.fitness > b.fitness)
	best_networks.clear()
	for i in range(min(5, current_brains.size())):
		best_networks.append(current_brains[i].brain.duplicate_network())
	generation += 1
