extends Node

const VERBOSE_DEBUG_MODE = false
const config_interface_scene = preload ("res://ConfigInterface/ConfigInterface.tscn")
var config_interface: Node
# If a spinbox has modified contents and the config interface is closed, 
# value_changed will emit just fine.
# However, this doesn't seem to be the case if the "normal window" is closed. 
# to combat this, Singleton will artificially update the spinboxes. 
# currently, the only used spinboxes' scripts are InputbarWidthSpinBox.gd and ScrollSpeedSpinBox.gd
# which append themselves to the config_interface_spinboxes array.
var config_interface_spinboxes = []

var btns = []

@onready
var root_node = get_node("/root/Node2D/Scaleable")
@onready
var ips_label: Label = root_node.get_node("IPS")

var inputs_gone = []
var ips = 0

var calibration
var deadzone = 0.5

var exiting: bool = false

func _ready():
	get_tree().set_auto_accept_quit(false)
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)

	# moved from ButtonHamburger.gd
	var hamburger = root_node.get_node("ButtonHamburger")
	hamburger.pressed.connect(show_config_window)

func update_window_bounds():
	var window_scale = ConfigHandler.current_config.window_scale # shortcut
	root_node.scale.x = window_scale
	root_node.scale.y = window_scale
	# var old_size: Vector2i = DisplayServer.window_get_size()
	# var old_min_size: Vector2i = DisplayServer.window_get_min_size()
	# InputBtn width is 50, so just 50*5
	# InputBtn height is 50, InputStrum height is 25,
	# but InputStrum is positioned 25 pixels lower, which adds up to 100
	var new_min_size: Vector2i = Vector2i(ceil(250 * window_scale), ceil(100 * window_scale))
	# print_debug("old_size: %s, old_min_size: %s, new_min_size: %s" % [old_size, old_min_size, new_min_size])
	DisplayServer.window_set_min_size(new_min_size)
	# if old_size == old_min_size:
	# 	DisplayServer.window_set_size(new_min_size+Vector2i(1,1))

func _on_joy_connection_changed(_device: int, _connected: bool):
	calibrate()

func calibrate():
	calibration = {}
	for joypad in Input.get_connected_joypads():
		var btn_list = {}
		for axis in range(11):
			btn_list[axis] = Input.get_joy_axis(joypad, axis)
		calibration[joypad] = btn_list
		
func process_axis_input(joypad, axis, value):
	if (calibration == null): calibrate()
	value = value - calibration[joypad][axis]
	var result = {}
	if abs(value) > deadzone:
		result["pressed"] = true
		result["positive"] = value > 0
	else:
		result["pressed"] = false
	return result

func _input(ev):
	if ev is InputEventKey and ev.pressed:
		if not ev.echo:
			# calibration keys (KEY_ASCIICIRCUM is ^)
			if ev.keycode == KEY_QUOTELEFT||ev.keycode == KEY_ASCIICIRCUM: calibrate()
		match (ev.keycode):
			KEY_MINUS: ConfigHandler.current_config.scroll_rate -= 10
			KEY_PLUS, KEY_EQUAL: ConfigHandler.current_config.scroll_rate += 10
			KEY_COMMA, KEY_BRACKETLEFT: ConfigHandler.current_config.input_bar_width -= 1
			KEY_PERIOD, KEY_BRACKETRIGHT: ConfigHandler.current_config.input_bar_width += 1
			KEY_BACKSPACE: inputs_gone = []
			KEY_ESCAPE: show_config_window()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# auto-calibration on app start; doesn't quite work in _ready()
	if (calibration == null): calibrate()
	
	# exiting is set to true when save_config_and_exit() is called
	if not exiting:
		# only do ips calculation if the ips are actually visisble
		if ConfigHandler.current_config.show_ips:
			var timestamp = Time.get_unix_time_from_system()
			var inputs_to_remove = []
			for i in inputs_gone.size():
				if timestamp - inputs_gone[i] >= 1:
					inputs_to_remove.insert(0, i)
			for x in inputs_to_remove:
				inputs_gone.remove_at(x)
			ips = len(inputs_gone)
			ips_label.text = "IPS: " + str(Singleton.ips)

func update_spinboxes():
		for spinbox in config_interface_spinboxes:
			spinbox.apply()

func update_window_border(value: bool):
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, value)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_config_and_exit()

func save_config_and_exit():
	exiting = true
	if config_interface != null:
		update_spinboxes()
	ConfigHandler.save_config()
	ConfigHandler.current_config.free()
	get_tree().quit()
	
func show_config_window():
	if config_interface == null:
		config_interface = config_interface_scene.instantiate()
		add_sibling(config_interface)
	config_interface.show()

func print_verbose(thing):
	if VERBOSE_DEBUG_MODE:
		print(thing)
