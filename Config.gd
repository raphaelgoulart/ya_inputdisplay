extends Object

var version: float = ConfigHandler.valid_config_versions[-1]

var scroll_rate: float = 400.0
var input_bar_width: int = 50
var always_show_hamburger: bool = true
var show_ips: bool = true
var borderless: bool = true
var window_scale: float = 1

# TODO: assign these to the inputbtns instead of storing them here
var colors = [Color.GREEN, Color.RED, Color.YELLOW, Color.BLUE, Color(1, 0.5, 0), Color(0.5, 0, 1), Color(0.5, 0, 1)]
