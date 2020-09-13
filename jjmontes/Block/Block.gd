extends TextureRect

var values = [" ", "1", "2", "3", "4", "5"]

var row
var column
var group

func _ready():
	set_value(" ")

func _on_Block_gui_input(event):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == BUTTON_LEFT:
		var pos = values.find(get_value())
		if (pos == -1):
			pos = 0
		pos += 1
		if (pos == values.size()):
			pos = 0
		
		set_value(values[pos])

func set_value(new_value):
	if values.find(new_value) > -1:
		$Label.text = new_value
	else:
		$Label.text = values[0]

func get_value():
	return $Label.text
