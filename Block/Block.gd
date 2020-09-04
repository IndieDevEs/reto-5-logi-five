extends ColorRect

var values = ["", "1", "2", "3", "4", "5"]

func _ready():
	$Text.text = values[0]

func red():
	color = Color.red

func yellow():
	color = Color.yellow

func blue():
	color = Color.blue

func green():
	color = Color.green

func fuchsia():
	color = Color.fuchsia

func _on_Block_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var idx = values.find($Text.text) + 1
		if idx == values.size():
			idx = 0
		$Text.text = values[idx]
