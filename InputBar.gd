extends Node

var released = false

var color
var rect: ColorRect
var timestamp
var x
var y
var caller

func set_caller(the_caller):
	caller = the_caller
	caller.released.connect(bar_release)

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = $ColorRect
	rect.color = color
	rect.color.a = 1
	x += floor((50 * ConfigHandler.current_config.window_scale - ConfigHandler.current_config.input_bar_width) / 2.0)
	rect.position.x = x
	rect.size.x = ConfigHandler.current_config.input_bar_width
	rect.position.y *= ConfigHandler.current_config.window_scale
	rect.position.y += y

func _process(delta):
	if rect.position.y > get_viewport().get_visible_rect().size.y:
		call_deferred("free")
	if not Singleton.exiting:
		if released:
			rect.position.y += ConfigHandler.current_config.scroll_rate * delta
		else:
			rect.size.y += ConfigHandler.current_config.scroll_rate * delta

func bar_release():
	released = true
	rect.size.y = (Time.get_unix_time_from_system() - timestamp) * ConfigHandler.current_config.scroll_rate
	if (rect.size.y < 1): rect.size.y = 1
	caller.released.disconnect(bar_release)
