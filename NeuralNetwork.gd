extends Node
class_name NeuralNetwork

var weights = [] # List of matrices
var biases = []  # List of vectors
var layers = []  # Sizes of layers, e.g., [4, 8, 1]

func _init(layer_sizes: Array):
	layers = layer_sizes
	for i in range(len(layers) - 1):
		var w = []
		for r in range(layers[i+1]):
			var row = []
			for c in range(layers[i]):
				row.append(randf_range(-1.0, 1.0))
			w.append(row)
		weights.append(w)
		
		var b = []
		for r in range(layers[i+1]):
			b.append(randf_range(-1.0, 1.0))
		biases.append(b)

func predict(inputs: Array) -> Array:
	var current = inputs
	for i in range(len(weights)):
		var next = []
		for r in range(len(weights[i])):
			var val = biases[i][r]
			for c in range(len(weights[i][r])):
				val += weights[i][r][c] * current[c]
			next.append(_activate(val))
		current = next
	return current

func _activate(x: float) -> float:
	return 1.0 / (1.0 + exp(-x)) # Sigmoid

func duplicate_network() -> NeuralNetwork:
	var nn = NeuralNetwork.new(layers)
	for i in range(len(weights)):
		for r in range(len(weights[i])):
			for c in range(len(weights[i][r])):
				nn.weights[i][r][c] = weights[i][r][c]
			nn.biases[i][r] = biases[i][r]
	return nn

func mutate(rate: float):
	for i in range(len(weights)):
		for r in range(len(weights[i])):
			for c in range(len(weights[i][r])):
				if randf() < rate:
					if randf() < 0.1: # 10% chance to completely randomize
						weights[i][r][c] = randf_range(-1.0, 1.0)
					else:
						weights[i][r][c] += randf_range(-0.3, 0.3)
			if randf() < rate:
				if randf() < 0.1:
					biases[i][r] = randf_range(-1.0, 1.0)
				else:
					biases[i][r] += randf_range(-0.3, 0.3)
