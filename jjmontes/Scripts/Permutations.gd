class_name Permutations

var _permutations = []
var _last_permutation = null
var _random = RandomNumberGenerator.new()

func _init():
	_init_permutations()
	to_first_permutation()

func next_permutation():
	_last_permutation += 1
	if _last_permutation > _permutations.size() - 1:
		return null
	return _permutations[_last_permutation]

func permutation_index():
	return _last_permutation

func to_first_permutation():
	_last_permutation = -1

func to_permutation(index):
	_last_permutation = index

func _init_permutations():
	while _permutations.size() < 120:
		var permutation = _create_permutation()
		while _permutations.find(permutation) == -1:
			_permutations.append(permutation)

func _create_permutation():
	var permutation = []
	
	while permutation.size() < 5:
		var value = _random.randi_range(1, 5)
		if (permutation.find(value) == -1):
			permutation.append(value)
	
	return permutation
