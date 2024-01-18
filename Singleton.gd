extends Node

var inputs_gone = []
var ips = 0
var scroll_rate = 400
var w = 50
var colors = ["#00FF00","#FF0000","#FFFF00","#0000FF","#FF8000","#8000FF","#8000FF"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: read bindings/calibration info
	var config = ConfigFile.new()
	var err = config.load("user://yaid_settings.cfg")
	if err != OK:
		print("error reading settings file; using default values...")
		return
	scroll_rate = config.get_value("Settings", "scroll_rate")
	w = config.get_value("Settings", "width")
	colors[0] = config.get_value("Colors", "green")
	colors[1] = config.get_value("Colors", "red")
	colors[2] = config.get_value("Colors", "yellow")
	colors[3] = config.get_value("Colors", "blue")
	colors[4] = config.get_value("Colors", "orange")
	colors[5] = config.get_value("Colors", "up")
	colors[6] = config.get_value("Colors", "down")
	
# TODO: calibration key receive + function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timestamp = Time.get_unix_time_from_system()
	var inputs_to_remove = []
	for i in inputs_gone.size():
		if timestamp - inputs_gone[i] >= 1:
			inputs_to_remove.append(i)
	for x in inputs_to_remove:
		inputs_gone.remove_at(x)
	ips = len(inputs_gone)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# TODO: save bindings/calibrations here
		# save settings here
		var config = ConfigFile.new()
		# Store some values.
		config.set_value("Settings", "scroll_rate", scroll_rate)
		config.set_value("Settings", "width", w)
		config.set_value("Colors", "green", colors[0])
		config.set_value("Colors", "red", colors[1])
		config.set_value("Colors", "yellow", colors[2])
		config.set_value("Colors", "blue", colors[3])
		config.set_value("Colors", "orange", colors[4])
		config.set_value("Colors", "up", colors[5])
		config.set_value("Colors", "down", colors[6])
		# Save it to a file (overwrite if already exists).
		config.save("user://yaid_settings.cfg")
		get_tree().quit() # default behavior
