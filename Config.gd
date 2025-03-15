extends Object

var version: float = 2.1

var scroll_rate: float = 400.0
var input_bar_width: int = 50
var always_show_hamburger: bool = true
var show_ips: bool = true

var waterfall_strums: bool = true
signal waterfall_strums_toggled
func set_waterfall_strums(new_value: bool):
	waterfall_strums = new_value
	# InputBtn width is 50, so just 50*5
	# InputBtn height is 50, InputStrum height is 25,
	# but InputStrum is positioned 25 pixels lower (below IPS), which adds up to 100
	var new_window_size = Vector2i(250, 100)
	if waterfall_strums:
		# more width space for all 7 waterfall effect buttons,
		# but less height since wide strums are hidden
		new_window_size = Vector2i(350,75)

	DisplayServer.window_set_min_size(new_window_size)
	waterfall_strums_toggled.emit()


# TODO: assign these to the inputbtns instead of storing them here
var colors = [Color.GREEN, Color.RED, Color.YELLOW, Color.BLUE, Color(1, 0.5, 0), Color(0.5, 0, 1), Color(0.5, 0, 1)]
