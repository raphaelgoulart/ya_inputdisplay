extends Window

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		hide()
