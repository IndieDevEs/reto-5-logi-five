extends TextureRect

var values = [" ", "1", "2", "3", "4", "5"]

var row
var column
var group

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = values[0]

func _on_Block_gui_input(event):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == BUTTON_LEFT:
		var pos = values.find($Label.text)
		if (pos == -1):
			pos = 0
		pos += 1
		if (pos == values.size()):
			pos = 0
		
		$Label.text = values[pos]
