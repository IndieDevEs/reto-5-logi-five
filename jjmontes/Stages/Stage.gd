extends GridContainer

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
	_make_stage(0)

func _make_stage(stage_index):
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
	pass
