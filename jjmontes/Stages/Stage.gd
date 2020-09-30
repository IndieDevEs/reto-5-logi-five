extends GridContainer

var _permutations_class = load("res://Scripts/Permutations.gd")

var _permutations = _permutations_class.new()
var block_scene = preload("res://Block/Block.tscn")
var background_default = Color(0.3,0.3,0.3,1.0)
var background_error = Color(0.6,0.2,0.2,1.0)
var background_win = Color(0.2,0.6,0.2,1.0)
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
	VisualServer.set_default_clear_color(background_default)
	_render_stage(0)
	var stage = stages[0]
	stage = _create_stage(stage)
	_draw_clues(stage)

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
	var stage = stages[0]
	if _is_complete(stage) == false or _is_valid(stage) == false:
		VisualServer.set_default_clear_color(background_error)
		yield(get_tree().create_timer(0.3), "timeout")
		VisualServer.set_default_clear_color(background_default)
	else:
		VisualServer.set_default_clear_color(background_win)

func _create_stage(stage):
	var current_row = 1
	_save_state(stage, true, null)
	while (_is_complete(stage) == false or _is_valid(stage) == false) and current_row <= 5:
		var row = _get_row(stage, current_row)
		var permutation = _permutations.next_permutation()
		if permutation == null:
			var discarded = _discard_state()
			_permutations.to_permutation(discarded.permutation_idx)
			stage = discarded.state
			current_row -= 1
			continue
		_put_permutation_into(permutation, row)
		_save_state(stage, _is_valid(stage), _permutations.permutation_index())
		if _is_valid(stage) == true:
			_permutations.to_first_permutation()
			current_row += 1
		else:
			var discarded = _discard_state()
			_permutations.to_permutation(discarded.permutation_idx)
			stage = discarded.state
	
	return stage

func _draw_clues(stage):
	var random = RandomNumberGenerator.new()
	var groups = _get_groups(stage)
	var clues = []
	for group_name in groups:
		var group = _get_group(stage, group_name)
		random.randomize()
		var block_idx = random.randi_range(0, group.size()-1)
		clues.append(group[block_idx])
	for child in get_children():
		for block in clues:
			if child.row == block.row and child.column == block.column:
				child.set_value(str(block.value))
				child.readonly()

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



var state = []

func _discard_state():
	var last_state = state.pop_back()
	#_to_csv("user://stage.csv", last_state)
	if last_state == null:
		return null
	return last_state.duplicate(true)

func _save_state(current_state, is_valid_state,permutation_idx):
	state.push_back({"state": current_state.duplicate(true), "permutation_idx": permutation_idx })
	_to_csv("user://stage.csv", current_state, is_valid_state)

func _is_complete(stage):
	for block in stage:
		if str(block.value) != " ":
			continue
		else:
			return false
	
	return true

func _put_permutation_into(permutation, blocks):
	for idx in range(0, 5):
		var value = permutation[idx]
		var block = blocks[idx]
		block.value = value

func _to_csv_head(file_name, file, content):
	var array = ["is_valid"]
	for item in content:
		array.append(str(item.row) + "-" + str(item.column) + "-" + str(item.group))
	file.open(file_name, File.WRITE_READ)
	var pool = PoolStringArray(array)
	file.store_csv_line(pool)
	file.close()

func _to_csv(file_name, content, is_valid_state):
	var file = File.new()
	if file.file_exists(file_name) != true:
		_to_csv_head(file_name, file, content)
	
	var array = [1 if is_valid_state == true else 0]
	for item in content:
		array.append(str(item.value))

	file.open(file_name, File.READ_WRITE)
	file.seek_end()
	var pool = PoolStringArray(array)
	file.store_csv_line(pool)
	file.close()

