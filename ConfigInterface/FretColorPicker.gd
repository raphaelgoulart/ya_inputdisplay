extends ColorPickerButton

var index: int
var label: Label

func _ready():
	label = $Label
	label.text = name
	if name == "strum_up":
		index = 5
		label.text = "Upstrum"
	elif name == "strum_down":
		index = 6
		label.text = "Downstrum"
	else:
		index = name.to_int()
	get_picker().color_modes_visible = false
	color = Color(ConfigHandler.current_config.colors[index], 1)
	update_label_color()
	color_changed.connect(_on_color_changed)

func update_label_color(): # make the label white if the color is dark and vice versa
	if color.get_luminance() < 0.5:
		label.modulate = Color.WHITE
	else:
		label.modulate = Color.BLACK
func _on_color_changed(_color):
	ConfigHandler.current_config.colors[index] = Color(color, 1)
	Singleton.btns[index].colorize(color)
	update_label_color()
