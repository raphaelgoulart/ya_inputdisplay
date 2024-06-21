extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.discardButton = self

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		pressed.connect(Singleton.save_config_and_exit)
