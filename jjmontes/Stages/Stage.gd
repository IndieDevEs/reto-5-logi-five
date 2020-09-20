extends GridContainer

var _permutations_class = load("res://Scripts/Permutations.gd")

var _random = RandomNumberGenerator.new()
var _permutations = _permutations_class.new()
var block_scene = preload("res://Block/Block.tscn")
var textures = [
	preload("res://Art/acronym8-blue.png"),
	preload("res://Art/acronym8-fucshia.png"),
	preload("res://Art/acronym8-green.png"),
	preload("res://Art/acronym8-red.png"),
	preload("res://Art/acronym8-yellow.png"),
]

var stages = [
	#Stage 001
	[
		{"row":1,"column":1,"group":"A","value":" "},
		{"row":1,"column":2,"group":"A","value":" "},
		{"row":1,"column":3,"group":"L","value":" "},
		{"row":1,"column":4,"group":"L","value":" "},
		{"row":1,"column":5,"group":"I","value":" "},
		
		{"row":2,"column":1,"group":"Y","value":" "},
		{"row":2,"column":2,"group":"A","value":" "},
		{"row":2,"column":3,"group":"A","value":" "},
		{"row":2,"column":4,"group":"L","value":" "},
		{"row":2,"column":5,"group":"I","value":" "},
		
		{"row":3,"column":1,"group":"Y","value":" "},
		{"row":3,"column":2,"group":"A","value":" "},
		{"row":3,"column":3,"group":"T","value":" "},
		{"row":3,"column":4,"group":"L","value":" "},
		{"row":3,"column":5,"group":"I","value":" "},
		
		{"row":4,"column":1,"group":"Y","value":" "},
		{"row":4,"column":2,"group":"Y","value":" "},
		{"row":4,"column":3,"group":"T","value":" "},
		{"row":4,"column":4,"group":"L","value":" "},
		{"row":4,"column":5,"group":"I","value":" "},
		
		{"row":5,"column":1,"group":"Y","value":" "},
		{"row":5,"column":2,"group":"T","value":" "},
		{"row":5,"column":3,"group":"T","value":" "},
		{"row":5,"column":4,"group":"T","value":" "},
		{"row":5,"column":5,"group":"I","value":" "},
	]
]

func _ready():
	_random.randomize()
	_render_stage(0)

func _render_stage(stage_index):
	var available_textures = textures.duplicate()
	var group_textures = {}
	var stage = stages[stage_index]
	for block in stage:
		var texture
		if group_textures.has(block.group) == false:
			texture = available_textures.pop_front()
			group_textures[block.group] = texture
		else:
			texture = group_textures[block.group]
			
		_add_block(block, texture)

func _add_block(block, texture):
	var block_instance = block_scene.instance()
	block_instance.row = block.row
	block_instance.column = block.column
	block_instance.group = block.group
	block_instance.texture = texture
	add_child(block_instance)

func _get_row(stage, number):
	var row = []
	for block in stage:
		if block.row == number:
			row.push_back(block)
	return row

func _get_column(stage, number):
	var col = []
	for block in stage:
		if block.column == number:
			col.push_back(block)
	return col

func _get_group(stage, name):
	var group = []
	for block in stage:
		if block.group == name:
			group.push_back(block)
	return group

func _get_groups(stage):
	var group = []
	for block in stage:
		if group.find(block.group) == -1:
			group.push_back(block.group)
	return group

func _on_Button_pressed():
	#TODO: Probando carga de Stage
	var stage = stages[0]
	_create_stage(stage)
	_draw_stage(stage)

func _create_stage(stage):
	for cell in stage:
		var next = _permutations.next_permutation()
		for value in next:
			cell.value = value

var stack = []

func _set_stack(stage):
	stack.push_back(stage)

func _draw_stage(stage):
	for child in get_children():
		for block in stage:
			if child.row == block.row and child.column == block.column:
				child.set_value(str(block.value))

func _is_valid(stage):
	return _is_valid_rows(stage) and _is_valid_columns(stage) and _is_valid_groups(stage)

func _is_valid_rows(stage):
	for row in range(1, 5):
		var values = [1, 2, 3, 4, 5]
		for block in _get_row(stage, row):
			if str(block.value) == " ":
				continue
			var idx = values.find(block.value)
			if idx > -1:
				values.remove(idx)
			else:
				return false
	return true

func _is_valid_columns(stage):
	for column in range(1, 5):
		var values = [1, 2, 3, 4, 5]
		for block in _get_column(stage, column):
			if str(block.value) == " ":
				continue
			var idx = values.find(block.value)
			if idx > -1:
				values.remove(idx)
			else:
				return false
	return true

func _is_valid_groups(stage):
	for group in _get_groups(stage):
		var values = [1, 2, 3, 4, 5]
		for block in _get_group(stage, group):
			if str(block.value) == " ":
				continue
			var idx = values.find(block.value)
			if idx > -1:
				values.remove(idx)
			else:
				return false
	return true













