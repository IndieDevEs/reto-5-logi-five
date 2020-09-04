extends Node2D

func _ready():
	pass # Replace with function body.

func _rotate():
	#rotate()
	rotation_degrees += 90
	for block in get_children():
		block.rotation_degrees -= 90
