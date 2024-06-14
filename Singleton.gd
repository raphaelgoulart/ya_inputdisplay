extends Node

var inputs_gone = []
var ips = 0
var scroll_rate = 400
var width = 50
var colors = ["#00FF00","#FF0000","#FFFF00","#0000FF","#FF8000","#8000FF","#8000FF"]
var config
var config_version = 1.1
var calibration
var deadzone = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	config = ConfigFile.new()
	var err = config.load("user://yaid_settings.cfg")
	if err != OK:
		print("error reading settings file; using default values...")
		return

	config_version = config.get_value("Meta", "config_version", 1) # assume config v1, because that config version doesn't have the "Meta" section.
	scroll_rate = config.get_value("Settings", "scroll_rate")
	width = config.get_value("Settings", "width")
	colors[0] = config.get_value("Colors", "green")
	colors[1] = config.get_value("Colors", "red")
	colors[2] = config.get_value("Colors", "yellow")
	colors[3] = config.get_value("Colors", "blue")
	colors[4] = config.get_value("Colors", "orange")
	colors[5] = config.get_value("Colors", "up")
	colors[6] = config.get_value("Colors", "down")
	
func calibrate():
	calibration = {}
	for joypad in Input.get_connected_joypads():
		var btn_list = {}
		for axis in range(11):
			btn_list[axis] = Input.get_joy_axis(joypad,axis)
		calibration[joypad] = btn_list
		
func process_axis_input(joypad,axis,value):
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
			# calibration key (`, keycode 96)
			if ev.keycode == 96: calibrate()
		match (ev.keycode):
			45:	scroll_rate -= 10 # -
			61:	scroll_rate += 10 # =
			91:	width -= 1 # [
			93:	width += 1 # ]
			4194308: inputs_gone = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# auto-calibration on app start; doesn't quite work in _ready()
	if (calibration == null): calibrate()
	
	var timestamp = Time.get_unix_time_from_system()
	var inputs_to_remove = []
	for i in inputs_gone.size():
		if timestamp - inputs_gone[i] >= 1:
			inputs_to_remove.insert(0, i)
	for x in inputs_to_remove:
		inputs_gone.remove_at(x)
	ips = len(inputs_gone)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		# save settings here
		var new_config = ConfigFile.new()
		# Store some values.
		new_config.set_value("Meta", "config_version", 1.1)
		new_config.set_value("Settings", "scroll_rate", scroll_rate)
		new_config.set_value("Settings", "width", width)
		new_config.set_value("Colors", "green", colors[0])
		new_config.set_value("Colors", "red", colors[1])
		new_config.set_value("Colors", "yellow", colors[2])
		new_config.set_value("Colors", "blue", colors[3])
		new_config.set_value("Colors", "orange", colors[4])
		new_config.set_value("Colors", "up", colors[5])
		new_config.set_value("Colors", "down", colors[6])
		# bindings
		var names = ["G","R","Y","B","O","U","D"]
		var i = 0
		for node_name in names:
			var node = get_node("/root/Node2D/" + node_name)
			new_config.set_value(str(i), "kb_btn", node.kb_btn)
			new_config.set_value(str(i), "gp_btn", node.gp_btn)
			new_config.set_value(str(i), "gp_axis", node.gp_axis)
			new_config.set_value(str(i), "gp_axis_device", node.gp_axis_device)
			new_config.set_value(str(i), "gp_axis_positive", node.gp_axis_positive)
			i += 1
		# Save it to a file (overwrite if already exists).
		new_config.save("user://yaid_settings.cfg")
		get_tree().quit() # default behavior
