extends Node

var inputs_gone = []
var ips = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
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
		print("quitting...") # TODO: save settings here
		get_tree().quit() # default behavior
